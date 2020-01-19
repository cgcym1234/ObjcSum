//
//  AudioPlayer.h
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>

@interface AudioPlayer : NSObject

- (instancetype)initWith:(AudioStreamBasicDescription *)desc;
- (BOOL)fillBuffer:(void *)buffer size:(int)size;
@end

