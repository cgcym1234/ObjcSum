//
//  NSDate+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSDate+YYExtension.h"

@implementation NSDate (YYExtension)

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)dayOfYear {
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    if ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0)) return YES;
    return NO;
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday {
    NSDate *added = [self yy_dateByAddingDays:1];
    return [added isToday];
}

- (NSDate *)yy_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yy_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yy_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yy_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)yy_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)yy_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)yy_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Formatted With Format
/**
 *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format
 *
 *  @param format NSString - String representing the desired date format
 *
 *  @return NSString representing the formatted date string
 */
-(NSString *)yy_stringWithFormat:(NSString *)format{
    return [self yy_stringWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}

/**
 *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and time zone
 *
 *  @param format   NSString - String representing the desired date format
 *  @param timeZone NSTimeZone - Desired time zone
 *
 *  @return NSString representing the formatted date string
 */
-(NSString *)yy_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone{
    return [self yy_stringWithFormat:format timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}

/**
 *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and locale
 *
 *  @param format NSString - String representing the desired date format
 *  @param locale NSLocale - Desired locale
 *
 *  @return NSString representing the formatted date string
 */
-(NSString *)yy_stringWithFormat:(NSString *)format locale:(NSLocale *)locale{
    return [self yy_stringWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:locale];
}

/**
 *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format, time zone and locale
 *
 *  @param format   NSString - String representing the desired date format
 *  @param timeZone NSTimeZone - Desired time zone
 *  @param locale   NSLocale - Desired locale
 *
 *  @return NSString representing the formatted date string
 */
-(NSString *)yy_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)yy_stringWithISOFormat {
    return [self yy_stringWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
}

/**日期进行下面4种情况的转换
 *  今天：  19：00
 *  昨天：  昨天 19：00
 *  本周：  周二 19：00
 *  其他：  2014年4月3日 19：00
 */
- (NSString *)yy_stringFromSelf {
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
                fmt = [[self yy_stringFromWeekday:selfWeekday] stringByAppendingString:@" HH:mm"];
            }
        }
    }
    
    return [self yy_stringWithFormat:fmt];
}

/** 数字1~7转换为周日~周六,否则返回未知
 *  1:周日
 *  2:周一
 ...
 */
- (NSString *)yy_stringFromWeekday:(NSInteger)weekday {
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
            return @"未知";
    }
}

#pragma mark - Date from string

+ (NSDate *)yy_dateWithString:(NSString *)dateString formatString:(NSString *)format {
    return [self yy_dateWithString:dateString formatString:format timeZone:[NSTimeZone defaultTimeZone]];
}

+ (NSDate *)yy_dateWithString:(NSString *)dateString formatString:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    return [self yy_dateWithString:dateString formatString:format timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}

+ (NSDate *)yy_dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    
    static NSDateFormatter *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[NSDateFormatter alloc] init];
    });
    
    parser.dateStyle = NSDateFormatterNoStyle;
    parser.timeStyle = NSDateFormatterNoStyle;
    parser.timeZone = timeZone;
    parser.dateFormat = formatString;
    parser.locale = locale;
    
    return [parser dateFromString:dateString];
}

+ (NSDate *)yy_dateWithISOFormatString:(NSString *)dateString {
    return [self yy_dateWithString:dateString formatString:@"yyyy-MM-dd'T'HH:mm:ssZ" timeZone:[NSTimeZone systemTimeZone] locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
}

@end
