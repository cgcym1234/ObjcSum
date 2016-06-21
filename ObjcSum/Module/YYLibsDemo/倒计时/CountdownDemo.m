//
//  CountdownDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "CountdownDemo.h"
#import "YYTimeManager.h"
#import "UIViewController+Extension.h"

#import "MSWeakTimer.h"
#import "DateTools.h"

@interface CountdownDemo ()<YYTimeManagerDelegate>

@property (nonatomic, assign) NSInteger secondsLeft;

@property (nonatomic, strong) NSString *deadline;
@property (nonatomic, strong) MSWeakTimer *timer;
@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, strong) YYTimeManager *timeManager;

@end

@implementation CountdownDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    
    _timeButton = [self addButtonWithTitle:@"00:00:00" action:^(UIButton *btn) {
        
    }];
    _timeButton.frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"start" action:^(UIButton *btn) {
        [weakSelf startTimming];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    
    [self addButtonWithTitle:@"pause" action:^(UIButton *btn) {
        [weakSelf.timeManager pause];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"reset" action:^(UIButton *btn) {
        [weakSelf.timeManager reset];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    
    
    self.deadline = @"2015-09-30 15:20";
//    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimming) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    
    self.timeManager = [[YYTimeManager alloc] init];
    self.timeManager.delegate = self;
    [_timeManager setCountDownTime:60];
}

- (void)dealloc {
    
}


- (void)deadlineChecking {
    NSDate *deadlineDate = [NSDate dateWithString:self.deadline formatString:@"yyyy-mm-dd HH:MM"];
    self.secondsLeft = [deadlineDate secondsLaterThan:[NSDate date]];
//    NSDate *date1970 = [NSDate dateWithTimeIntervalSince1970:0];
}

- (void)reset {
    
}



- (void)startTimming {
    [self.timeManager start];
}


- (void)yyTimeManager:(YYTimeManager *)timeManager countingToTime:(NSTimeInterval)time timeText:(NSString *)timeText {
    [self.timeButton setTitle:timeText forState:UIControlStateNormal];
    NSLog(@"%@", timeText);
}

- (void)yyTimeManager:(YYTimeManager *)timeManager didFinishCountDownAtTime:(NSTimeInterval)time timeText:(NSString *)timeText {
    
}
@end
