//
//  YYTimeManager.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/5.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYTimeManager.h"
#import "MSWeakTimer.h"

#define kDefaultTimeFormat  @"HH:mm:ss"
#define kDefaultFireInterval  0.1

static NSDate *date1970;

@interface YYTimeManager ()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *deadline;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) MSWeakTimer *timer;

@property (nonatomic, assign) NSTimeInterval timeLeftTotal;

@end

@implementation YYTimeManager

+ (void)load {
    date1970 = [NSDate dateWithTimeIntervalSince1970:0];
}

- (instancetype)init {
    if (self = [super init]) {
        [self envInit];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Private
- (void)envInit {
    [self setTimeFormatter:kDefaultTimeFormat];
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    return _dateFormatter;
}

- (void)updateTime {
    NSTimeInterval timeLeft = [_deadline timeIntervalSinceDate:[NSDate date]];
    NSDate *timeToShow = [date1970 dateByAddingTimeInterval:timeLeft];
    NSString *timeText = [_dateFormatter stringFromDate:timeToShow];
    if (timeLeft > 0) {
        if ([_delegate respondsToSelector:@selector(yyTimeManager:countingToTime:timeText:)]) {
            [_delegate yyTimeManager:self countingToTime:timeLeft timeText:timeText];
        }
    } else {
        [_timer invalidate];
        if ([_delegate respondsToSelector:@selector(yyTimeManager:didFinishCountDownAtTime:timeText:)]) {
            [_delegate yyTimeManager:self didFinishCountDownAtTime:timeLeft timeText:timeText];
        }
    }
}

#pragma mark - Public

-(void)setCountDownTime:(NSTimeInterval)time {
    _timeLeftTotal = time < 0 ? 0 : time;
}

//设置倒计时截至时间
-(void)setCountDownToDate:(NSDate *)date {
    NSDate *curDate = [NSDate date];
    _deadline = [date timeIntervalSinceDate:curDate] <= 0 ? curDate : [date copy];
}

- (void)setTimeFormatter:(NSString *)timeFormatter {
    if (timeFormatter.length == 0) {
        return;
    }
    _timeFormatter = timeFormatter;
    self.dateFormatter.dateFormat = timeFormatter;
}

- (void)start {
    [self pause];
    
    if (!_deadline) {
        _startDate = [NSDate date];
        _deadline = [_startDate dateByAddingTimeInterval:_timeLeftTotal];
    }
    
    _timer = [[MSWeakTimer alloc] initWithTimeInterval:kDefaultFireInterval target:self selector:@selector(updateTime) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [_timer schedule];
}

- (void)pause {
    [_timer invalidate];
}

- (void)reset {
    _startDate = [NSDate date];
    _deadline = [_startDate dateByAddingTimeInterval:_timeLeftTotal];
    [self start];
}

@end
