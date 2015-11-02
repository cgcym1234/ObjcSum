//
//  NSDate+Extension.m
//  MLLCustomer
//
//  Created by sihuan on 15/5/11.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "NSDate+Extension.h"
#import "DateTools.h"

@implementation NSDate (Extension)

/**日期进行下面4种情况的转换
 *  今天：  19：00
 *  昨天：  昨天 19：00
 *  本周：  周二 19：00
 *  其他：  2014年4月3日 19：00
 */
- (NSString *)dateToVisbleStr{
    NSString *fmt = @"yyyy年M月d日 HH:mm";;
    NSDate *cur = [NSDate date];
    
    NSInteger curYear = [cur year];
    NSInteger curWeekOfYear = [cur weekOfYear];
    //NSInteger curWeekday = [cur weekday];
    NSInteger curDayOfYear = [cur dayOfYear];
    
    NSInteger selfYear = [self year];
    NSInteger selfWeekOfYear = [self weekOfYear];
    NSInteger selfWeekday = [self weekday];
    NSInteger selfDayOfYear = [self dayOfYear];
    
    
    if (selfYear == curYear) {
        //本周
        if (selfWeekOfYear == curWeekOfYear) {
            //今天
            if (selfDayOfYear == curDayOfYear) {
                fmt = @"HH:mm";
            } else if (selfDayOfYear == curDayOfYear - 1) {//昨天
                fmt = @"昨天 HH:mm";
            } else {
                fmt = [[self getWeekdayStr:selfWeekday] stringByAppendingString:@" HH:mm"];
            }
        }
    }
    
    return [self formattedDateWithFormat:fmt];
}

- (NSString *)getWeekdayStr:(NSInteger)weekday {
    switch (weekday) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            return @"周八";
    }
}

@end
