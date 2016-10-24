//
//  YYGCDTimer.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYGCDTimer.h"

@interface YYGCDTimer ()

@property (nonatomic, strong, readwrite) dispatch_source_t dispatchSource;

@end

@implementation YYGCDTimer


#pragma 初始化以及释放
- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    return self;
}
- (instancetype)initInQueue:(YYGCDQueue *)queue {
    self = [super init];
    if (self)
    {
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
    }
    return self;
}

#pragma 用法
- (void)event:(dispatch_block_t)block timeInterval:(NSTimeInterval)sec {
    dispatch_source_set_timer(self.dispatchSource, DISPATCH_TIME_NOW, NSEC_PER_SEC * sec, 0);
    
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)start {
    dispatch_resume(self.dispatchSource);
}

- (void)destory {
    dispatch_source_cancel(self.dispatchSource);
}


@end
