//
//  AudioQueueModel.h
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AudioQueueModel : NSObject
@property (assign, nonatomic) AudioQueueRef queue;
@property (assign, nonatomic) AudioQueueBufferRef buffer;

+ (instancetype)modelWith:(AudioQueueBufferRef)buffer queue:(AudioQueueRef)queue;
@end
