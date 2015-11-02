//
//  MLLUncaughtExceptionHandler.m
//  MeileleForiPad
//
//  Created by chester on 7/21/14.
//  Copyright (c) 2014 caoping. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

volatile int32_t MLLUncaughtExceptionCount = 0;
const int32_t MLLUncaughtExceptionMaximum = 10;
NSString * const MLLUncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const MLLUncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
NSString * const MLLUncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
const NSInteger MLLUncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger MLLUncaughtExceptionHandlerReportAddressCount = 5;

void HandleException(NSException *exception);
void SignalHandler(int signal);


@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = MLLUncaughtExceptionHandlerSkipAddressCount;
         i < MLLUncaughtExceptionHandlerSkipAddressCount + MLLUncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}


- (void)handleException:(NSException *)exception
{
    NSLog(@"崩溃日志》》》\r\n%@",[NSString stringWithFormat:NSLocalizedString(@"%@   %@   %@", nil),
                             [exception name],
                             [exception reason],
                             [[exception userInfo] objectForKey:MLLUncaughtExceptionHandlerAddressesKey]]);
   
    //TODO:写崩溃日志文件（如果需要本地化）
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    
    //TODO:保存崩溃前的数据结构
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"test1" forKey:@"110Test"];
//    [userDefaults synchronize];

//    [ShopCarUserDataManager updateUserLoginRecord:shopCarDataKey];
//    [ShopCarUserDataManager updateShopCarUserData:shopCarDataKey];
    
    if ([[exception name] isEqual:MLLUncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:MLLUncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}


@end

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&MLLUncaughtExceptionCount);
    if (exceptionCount > MLLUncaughtExceptionMaximum)
    {
        return;
    }

    
    NSArray *callStack = [exception callStackSymbols];//[UncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:MLLUncaughtExceptionHandlerAddressesKey];
    
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&MLLUncaughtExceptionCount);
    if (exceptionCount > MLLUncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:MLLUncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    [userInfo
     setObject:callStack
     forKey:MLLUncaughtExceptionHandlerAddressesKey];
    
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException exceptionWithName:MLLUncaughtExceptionHandlerSignalExceptionName
      reason: [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil),signal]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void InstallExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
