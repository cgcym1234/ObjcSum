//
//  YYGlobalTimerDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYGlobalTimerDemo.h"
#import "YYGlobalTimer.h"
#import "YYLogger.h"
#import "NSString+YYSDK.h"
#include <sys/sysctl.h>

@interface YYGlobalTimerDemo ()

@end

@implementation YYGlobalTimerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYGlobalTimer addTaskForKey:@"task1" interval:0.1111 action:^(NSDate *currentDate){
        yyLogDebug(@"task1   %@", [NSDate date]);
    } executedInMainThread:YES];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task2" interval:0.323 action:^(NSDate *currentDate){
        yyLogInfo(@"task2   %@", [NSDate date]);
    } executedInMainThread:NO];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task3" interval:1.999 action:^(NSDate *currentDate){
        yyLogError(@"task3   %@", [NSDate date]);
    } executedInMainThread:NO];
}


- (void)dealloc {
    //移除掉默认 task1即可，task2和task3会因为自己释放而自动从YYGlobalTimer中移除
    [YYGlobalTimer removeTaskForKey:@"task1"];
}


//get system uptime since last boot
- (NSTimeInterval)uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    
    struct timeval now;
    struct timezone tz;
    gettimeofday(&now, &tz);
    
    double uptime = -1;
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now.tv_sec - boottime.tv_sec;
        uptime += (double)(now.tv_usec - boottime.tv_usec) / 1000000.0;
    }
    return uptime;
}

@end








