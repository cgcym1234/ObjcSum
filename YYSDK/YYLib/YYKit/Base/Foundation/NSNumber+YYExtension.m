//
//  NSNumber+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSNumber+YYExtension.h"
#import "NSString+YYExtension.h"
#import "NSDate+YYExtension.h"

@implementation NSNumber (YYExtension)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (NSNumber *)yy_numberWithString:(NSString *)string {
    NSString *str = [[string yy_stringByTrim] lowercaseString];
    if (!str || str.length == 0) {
        return nil;
    }
    
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@"true" :   @(YES),
                 @"yes" :    @(YES),
                 @"false" :  @(NO),
                 @"no" :     @(NO),
                 @"nil" :    [NSNull null],
                 @"null" :   [NSNull null],
                 @"<null>" : [NSNull null]};
    });
    
    NSNumber *num = dict[str];
    if (num) {
        if ([num isKindOfClass:[NSNull class]]) {
            num = nil;
        }
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) {
        sign = 1;
    } else if ([str hasPrefix:@"-0x"]) {
        sign = -1;
    }
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL success = [scan scanHexInt:&num];
        if (success) {
            return @(num);
        } else {
            return nil;
        }
    }
    
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
    
}

/**
 *  将毫秒转换成NSDate
 */
- (NSDate *)yy_dateFromMilisecondNumber {
    NSTimeInterval doubleValue = [self doubleValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:doubleValue];
    return date;
}

/**
 *  毫秒转换成指定的日期的NSString格式，默认是@"yyyy-MM-dd HH:mm:ss"
 */
- (NSString *)yy_stringFromMilisecondNumberWithFormat:(NSString *)format {
    NSDate *date = [self yy_dateFromMilisecondNumber];
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return [date yy_stringWithFormat:format];
}

@end
