//
//  NSString+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSString+YYMessage.h"
#import "NSDate+YYMessage.h"

@implementation NSString (YYMessage)
+ (void)load {
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[self directoryMessageHome] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self directoryMessageHomeImages] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self directoryMessageHomeVoices] withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString *)directoryUserLibrary {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)directoryMessageHome {
    return [[self directoryUserLibrary] stringByAppendingPathComponent:@"YYMessage"];
}
+ (NSString *)directoryMessageHomeImages {
    return [[self directoryMessageHome] stringByAppendingPathComponent:@"images"];
}
+ (NSString *)directoryMessageHomeVoices {
    return [[self directoryMessageHome] stringByAppendingPathComponent:@"voices"];
}

//  xxxxx/yyyy/MM/dd
+ (NSString *)directoryCurrentTimestampWithRootPath:(NSString *)rootPath {
    NSDate *currentDate = [NSDate date];
    
    //yyyy/MM/dd/hh
    NSString *datePath = [currentDate stringWithDefaultFormat];
    NSString *filePath = [rootPath stringByAppendingPathComponent:datePath];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return filePath;

//    NSString *fileName = [NSString stringWithFormat:@"%.lf", currentDate.timeIntervalSince1970*1000*1000];
//    return [filePath stringByAppendingPathComponent:fileName];
}

/**
 *  根据当前时间戳生成图片路径，自动创建需要的目录，按天存储
 */
+ (NSString *)directoryForImageByCurrentTimestamp {
    return [self directoryCurrentTimestampWithRootPath:[self directoryMessageHomeImages]];
}
/**
 *  根据当前时间戳生成语音路径，自动创建需要的目录，按天存储
 */
+ (NSString *)directoryForVoiceByCurrentTimestamp {
    return [self directoryCurrentTimestampWithRootPath:[self directoryMessageHomeVoices]];
}
@end
