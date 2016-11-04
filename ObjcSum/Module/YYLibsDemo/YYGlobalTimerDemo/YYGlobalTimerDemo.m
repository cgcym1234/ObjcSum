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

@interface YYGlobalTimerDemo ()

@end

@implementation YYGlobalTimerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYGlobalTimer addTaskForKey:@"task1" interval:0.1111 action:^{
        yyLogDebug(@"task1   %@", [NSDate date]);
    } executedInMainThread:YES];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task2" interval:0.323 action:^{
        yyLogInfo(@"task2   %@", [NSDate date]);
    } executedInMainThread:NO];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task3" interval:1.999 action:^{
        yyLogError(@"task3   %@", [NSDate date]);
    } executedInMainThread:NO];
}


- (void)dealloc {
    //移除掉默认 task1即可，task2和task3会因为自己释放而自动从YYGlobalTimer中移除
    [YYGlobalTimer removeTaskForKey:@"task1"];
}

@end








