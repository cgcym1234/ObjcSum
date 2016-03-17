//
//  NSString+YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 16/1/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YYMessage)

+ (NSString *)directoryUserLibrary;

//~/Libaray/YYMessage
+ (NSString *)directoryMessageHome;

//~/Libaray/YYMessage/images
+ (NSString *)directoryMessageHomeImages;
//~/Libaray/YYMessage/voices
+ (NSString *)directoryMessageHomeVoices;

//yyyy/MM/dd/hh/xxxxxxxxxxx
+ (NSString *)directoryCurrentTimestampWithRootPath:(NSString *)rootPath;

/**
 *  根据当前时间戳生成图片完整路径，自动创建需要的目录
 */
+ (NSString *)fullPathOfImageByCurrentTimestamp;
/**
 *  根据当前时间戳生成语音完整路径，自动创建需要的目录
 */
+ (NSString *)fullPathOfVoiceByCurrentTimestamp;
@end
