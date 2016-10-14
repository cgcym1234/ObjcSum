//
//  NSNumber+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (YYExtension)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (NSNumber *)yy_numberWithString:(NSString *)string;

/**
 *  将毫秒转换成NSDate
 */
- (NSDate *)yy_dateFromMilisecondNumber;

/**
 *  毫秒转换成指定的日期的NSString格式，默认是@"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)yy_stringFromMilisecondNumberWithFormat:(NSString *)format;


@end
