
//
//  YYMessageObjectAudio.m
//  ObjcSum
//
//  Created by sihuan on 16/3/15.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageObjectAudio.h"
#import "NSURL+YYMessage.h"

@interface YYMessageObjectAudio ()

/**
 *  语音的本地路径
 */
@property (nonatomic, copy) NSURL *locolURL;

/**
 *  语音的远程路径
 */
@property (nonatomic, copy) NSURL *remoteURL;

/**
 *  语音时长，毫秒为单位
 */
@property (nonatomic, assign)  NSInteger duration;

@end

@implementation YYMessageObjectAudio

- (instancetype)initWithAudioURL:(NSURL *)audioURL {
    self = [super init];
    if (self) {
        _locolURL = audioURL;
        _duration = [audioURL durationMilisecond];
    }
    return self;
}

- (YYMessageType)type {
    return YYMessageTypeAudio;
}

@end
