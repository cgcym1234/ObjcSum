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

//  xxxxx/yyyy/MM/dd
+ (NSString *)directoryCurrentTimestampWithRootPath:(NSString *)rootPath;

/**
 *  根据当前时间戳生成图片路径，自动创建需要的目录，按天存储
 */
+ (NSString *)directoryForImageByCurrentTimestamp;
/**
 *  根据当前时间戳生成语音路径，自动创建需要的目录，按天存储
 */
+ (NSString *)directoryForVoiceByCurrentTimestamp;
@end
