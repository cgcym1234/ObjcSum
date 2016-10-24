//
//  YYGCDQueue.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYGCDQueue.h"

static YYGCDQueue *mainQueue;
static YYGCDQueue *globalQueue;
static YYGCDQueue *highPriorityGlobalQueue;
static YYGCDQueue *lowPriorityGlobalQueue;
static YYGCDQueue *backgroundPriorityGlobalQueue;

@interface YYGCDQueue ()

@property (nonatomic, strong, readwrite) dispatch_queue_t dispatchQueue;

@end

@implementation YYGCDQueue

#pragma mark - GetQueue
+ (YYGCDQueue *)mainQueue {
    return mainQueue;
}

+ (YYGCDQueue *)globalQueue {
    return globalQueue;
}

+ (YYGCDQueue *)highPriorityGlobalQueue {
    return highPriorityGlobalQueue;
}

+ (YYGCDQueue *)lowPriorityGlobalQueue {
    return lowPriorityGlobalQueue;
}

+ (YYGCDQueue *)backgroundPriorityGlobalQueue {
    return backgroundPriorityGlobalQueue;
}

+ (void)load {
    mainQueue = [[YYGCDQueue alloc] init];
    mainQueue.dispatchQueue = dispatch_get_main_queue();
    
    globalQueue = [YYGCDQueue new];
    globalQueue.dispatchQueue = \
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    highPriorityGlobalQueue = [YYGCDQueue new];
    highPriorityGlobalQueue.dispatchQueue = \
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    lowPriorityGlobalQueue = [YYGCDQueue new];
    lowPriorityGlobalQueue.dispatchQueue = \
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    backgroundPriorityGlobalQueue = [YYGCDQueue new];
    backgroundPriorityGlobalQueue.dispatchQueue = \
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
}

#pragma - 初始化
- (instancetype)init {
    return [self initSerial];
}

- (instancetype)initSerial {
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initConcurrent {
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma 用法
- (void)execute:(dispatch_block_t)block {
    dispatch_async(self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelaySec:(int64_t)sec
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue, block);
}

- (void)waitExecute:(dispatch_block_t)block
{
    /*
     As an optimization, this function invokes the block on
     the current thread when possible.
     
     作为一个建议,这个方法尽量在当前线程池中调用.
     */
    dispatch_sync(self.dispatchQueue, block);
}

- (void)barrierExecute:(dispatch_block_t)block
{
    /*
     The queue you specify should be a concurrent queue that you
     create yourself using the dispatch_queue_create function.
     If the queue you pass to this function is a serial queue or
     one of the global concurrent queues, this function behaves
     like the dispatch_async function.
     
     使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
     或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的async操作
     */
    dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)waitBarrierExecute:(dispatch_block_t)block
{
    /*
     The queue you specify should be a concurrent queue that you
     create yourself using the dispatch_queue_create function.
     If the queue you pass to this function is a serial queue or
     one of the global concurrent queues, this function behaves
     like the dispatch_sync function.
     
     使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
     或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的sync操作
     
     As an optimization, this function invokes the barrier block
     on the current thread when possible.
     
     作为一个建议,这个方法尽量在当前线程池中调用.
     */
    
    dispatch_barrier_sync(self.dispatchQueue, block);
}

- (void)suspend {
    dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
    dispatch_resume(self.dispatchQueue);
}

#pragma 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(YYGCDGroup *)group {
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)notify:(dispatch_block_t)block inGroup:(YYGCDGroup *)group {
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

#pragma 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block {
    [[YYGCDQueue mainQueue] execute:block];
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block {
    [[YYGCDQueue globalQueue] execute:block];
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block {
    [[YYGCDQueue highPriorityGlobalQueue] execute:block];
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block {
    [[YYGCDQueue lowPriorityGlobalQueue] execute:block];
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block {
    [[YYGCDQueue backgroundPriorityGlobalQueue] execute:block];
}

+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    [[YYGCDQueue mainQueue] execute:block afterDelaySec:sec];
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    [[YYGCDQueue globalQueue] execute:block afterDelaySec:sec];
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    [[YYGCDQueue highPriorityGlobalQueue] execute:block afterDelaySec:sec];
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    [[YYGCDQueue lowPriorityGlobalQueue] execute:block afterDelaySec:sec];
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    [[YYGCDQueue backgroundPriorityGlobalQueue] execute:block afterDelaySec:sec];
}


@end
