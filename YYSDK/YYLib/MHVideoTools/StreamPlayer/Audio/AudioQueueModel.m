//
//  AudioQueueModel.m
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import "AudioQueueModel.h"

@implementation AudioQueueModel
+ (instancetype)modelWith:(AudioQueueBufferRef)buffer queue:(AudioQueueRef)queue
{
    AudioQueueModel *model = [[self alloc] init];
    model.queue = queue;
    model.buffer = buffer;
    return model;
}

- (NSString *)description
{
    NSLog(@"reking description");
    return [NSString stringWithFormat:@"self.queue:%p self.buffer:%p", self.queue, self.buffer];
}

@end
