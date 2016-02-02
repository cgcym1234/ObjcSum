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

//~/Libaray/YYMessage/Images
+ (NSString *)directoryMessageHomeImages;
+ (NSString *)directoryMessageHomeVoices;

@end
