//
//  Recorder.h
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/6/1.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Recorder : NSObject

@property (strong, nonatomic) void(^bufferCallback)(AudioQueueBufferRef, AudioQueueRef);

- (instancetype)initWith:(AudioStreamBasicDescription *)desc;
- (void)start;
- (void)stop;
- (void)pause;

@end
