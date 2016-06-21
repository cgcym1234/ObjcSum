//
//  YYMessageObjectAudio.h
//  ObjcSum
//
//  Created by sihuan on 16/3/15.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageObject.h"

@interface YYMessageObjectAudio : NSObject
<YYMessageObject>

/**
 *  语音对象初始化方法
 *
 *  @param audioURL 语音路径
 *
 *  @return 语音实例对象
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL;

@property (nonatomic, weak) YYMessage *message;

/**
 *  语音的本地路径
 */
@property (nonatomic, copy, readonly) NSURL *locolURL;

/**
 *  语音的远程路径
 */
@property (nonatomic, copy, readonly) NSURL *remoteURL;

/**
 *  语音时长，毫秒为单位
 */
@property (nonatomic, assign, readonly)  NSInteger duration;

@end
