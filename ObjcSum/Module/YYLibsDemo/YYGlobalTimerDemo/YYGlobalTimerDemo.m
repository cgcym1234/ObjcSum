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
    
    [YYGlobalTimer addTaskForKey:@"task1" action:^{
        yyLogInfo(@"task1   %@", [NSDate date]);
    } executedInMainThread:YES];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task2" action:^{
        yyLogInfo(@"task2   %@", [NSDate date]);
    } executedInMainThread:NO];
    
    [YYGlobalTimer addTaskForTarget:self key:@"task3" action:^{
        yyLogInfo(@"task3   %@", [NSDate date]);
    } executedInMainThread:NO];
}


- (void)dealloc {
    //移除掉默认 task1即可，task2和task3会因为自己释放而自动从YYGlobalTimer中移除
    [YYGlobalTimer removeTaskForKey:@"task1"];
}

@end








