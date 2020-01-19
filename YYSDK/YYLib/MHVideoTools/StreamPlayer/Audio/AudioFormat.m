//
//  AudioFormat.m
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import "AudioFormat.h"

@implementation AudioFormat
+ (AudioStreamBasicDescription)defaultFormat
{
    AudioStreamBasicDescription desc;
    memset(&desc, 0, sizeof(desc));
    
    desc.mSampleRate = 8000;
    desc.mFormatID = kAudioFormatULaw ;
    desc.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    desc.mFramesPerPacket = 1;
    desc.mChannelsPerFrame = 1;
    desc.mBitsPerChannel = 16;
    
    desc.mBytesPerFrame = (desc.mBitsPerChannel/8)  * desc.mChannelsPerFrame;
    desc.mBytesPerPacket = desc.mBytesPerFrame * desc.mFramesPerPacket;
    
    return desc;
}
@end
