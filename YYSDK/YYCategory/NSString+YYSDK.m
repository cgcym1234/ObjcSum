//
//  NSString+YYSDK.m
//  ObjcSum
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSString+YYSDK.h"

@implementation NSString (YYSDK)

/* return @" " */
+ (NSString *)blank {
    return @" ";
}

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

/* Trims white space and new line characters, returns a new string */
- (NSString *)trimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

















