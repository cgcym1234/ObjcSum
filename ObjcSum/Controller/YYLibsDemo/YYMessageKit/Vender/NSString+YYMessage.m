//
//  NSString+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSString+YYMessage.h"

@implementation NSString (YYMessage)

+ (NSString *)directoryUserLibrary {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)directoryMessageHome {
    return [[self directoryUserLibrary] stringByAppendingPathComponent:@"YYMessage"];
}
+ (NSString *)directoryMessageHomeImages {
    return [[self directoryMessageHome] stringByAppendingPathComponent:@"Images"];
}
+ (NSString *)directoryMessageHomeVoices {
    return [[self directoryMessageHome] stringByAppendingPathComponent:@"Voices"];
}
@end
