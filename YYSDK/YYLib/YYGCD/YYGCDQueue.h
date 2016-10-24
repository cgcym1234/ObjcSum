//
//  YYGCDQueue.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYGCDGroup.h"


@interface YYGCDQueue : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t dispatchQueue;

#pragma mark - GetQueue
+ (YYGCDQueue *)mainQueue;
+ (YYGCDQueue *)globalQueue;
+ (YYGCDQueue *)highPriorityGlobalQueue;
+ (YYGCDQueue *)lowPriorityGlobalQueue;
+ (YYGCDQueue *)backgroundPriorityGlobalQueue;

#pragma 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initConcurrent;

#pragma 用法
- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;
- (void)waitExecute:(dispatch_block_t)block;
- (void)barrierExecute:(dispatch_block_t)block;
- (void)waitBarrierExecute:(dispatch_block_t)block;
- (void)suspend;
- (void)resume;

#pragma 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(YYGCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(YYGCDGroup *)group;

@end
