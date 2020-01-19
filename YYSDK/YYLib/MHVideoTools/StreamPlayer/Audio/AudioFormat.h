//
//  AudioFormat.h
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudioKit/CoreAudioKit.h>
@interface AudioFormat : NSObject
+ (AudioStreamBasicDescription)defaultFormat;
@end
