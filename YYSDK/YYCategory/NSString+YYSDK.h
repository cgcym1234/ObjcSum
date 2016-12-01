//
//  NSString+YYSDK.h
//  ObjcSum
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YYSDK)

/* 
 return @" " 
 */
+ (NSString *)blank;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/* Trims white space and new line characters, returns a new string */
- (NSString *)trimmed;

- (NSString *)toUnicodeString;
- (NSString *)toUnUnicodeString;


@end
