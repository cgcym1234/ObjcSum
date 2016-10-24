//
//  YYGCDGroup.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYGCDGroup.h"

@interface YYGCDGroup ()

@property (nonatomic, strong, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation YYGCDGroup

- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}

- (void)enter {
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(NSTimeInterval)sec {
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec)) == 0;
}


@end
