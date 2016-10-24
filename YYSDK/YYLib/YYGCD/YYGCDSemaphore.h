//
//  YYGCDSemaphore.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYGCDSemaphore : NSObject

@property (nonatomic, strong, readonly) dispatch_semaphore_t dispatchSemaphore;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initWithValue:(long)value;

#pragma 用法
- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(NSTimeInterval)sec;

/*
 GCDSemaphore *sem = [[GCDSemaphore alloc] init];
 
 GCDTimer *timer = [[GCDTimer alloc] initInQueue:[GCDQueue globalQueue]];
 [timer event:^{
 [sem signal];
 } timeInterval:NSEC_PER_SEC];
 [timer start];
 
 [[GCDQueue globalQueue] execute:^{
 while (1)
 {
 [sem wait];
 NSLog(@"Y.X.");
 }
 }];
 
 
 一个发送信号,一个接受信号
 
 -dispatch_semaphore_signal-
 
 Signals (increments) a semaphore.
 Increment the counting semaphore. If the previous value was less than zero, this function wakes a thread currently waiting in dispatch_semaphore_wait.
 
 This function returns non-zero if a thread is woken. Otherwise, zero is returned.
 
 发送信号增加一个信号量.
 
 增加一个信号量,如果当前值小于或者等于0,这个方法会唤醒某个使用了dispatch_semaphore_wait的线程.
 
 如果这个线程已经唤醒了,将会返回非0值,否则返回0
 */
@end
