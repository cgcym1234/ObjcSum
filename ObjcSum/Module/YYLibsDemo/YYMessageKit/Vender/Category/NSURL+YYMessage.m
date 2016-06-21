//
//  NSURL+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/3/15.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSURL+YYMessage.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSURL (YYMessage)

/**
 *  获取音频或视频时间，单位毫秒
 */
- (NSInteger)durationMilisecond {
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self options:nil];
    CMTime audioDuration = audioAsset.duration;
    return CMTimeGetSeconds(audioDuration) * 1000;
}

@end
