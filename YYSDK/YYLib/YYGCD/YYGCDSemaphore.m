//
//  YYGCDSemaphore.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYGCDSemaphore.h"

@interface YYGCDSemaphore ()

@property (nonatomic, strong, readwrite) dispatch_semaphore_t dispatchSemaphore;

@end


@implementation YYGCDSemaphore

- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (instancetype)initWithValue:(long)value
{
    self = [super init];
    if (self)
    {
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    return self;
}

- (BOOL)signal {
    //returns non-zero if a thread is woken. Otherwise, zero is returned.
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(NSTimeInterval)sec {
    // Returns zero on success, or non-zero if the timeout occurred.
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec)) == 0;
}

@end
