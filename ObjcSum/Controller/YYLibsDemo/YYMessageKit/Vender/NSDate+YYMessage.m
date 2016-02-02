//
//  NSDate+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSDate+YYMessage.h"

@implementation NSDate (YYMessage)

//默认yyyy/MM/dd/hh
- (NSString *)stringWithDefaultFormat {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd/hh"];
        [formatter setLocale:[NSLocale currentLocale]];
    }
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

@end
