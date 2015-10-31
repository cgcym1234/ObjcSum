//
//  YYTimeManager.h
//  MySimpleFrame
//
//  Created by sihuan on 15/9/5.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYTimeManager;
@protocol YYTimeManagerDelegate <NSObject>

@optional

- (void)yyTimeManager:(YYTimeManager*)timeManager countingToTime:(NSTimeInterval )time timeText:(NSString *)timeText;

- (void)yyTimeManager:(YYTimeManager*)timeManager didFinishCountDownAtTime:(NSTimeInterval)time timeText:(NSString *)timeText;

@end

@interface YYTimeManager : NSObject

@property (nonatomic, weak) id<YYTimeManagerDelegate> delegate;

@property (nonatomic, copy) NSString *timeFormatter;
@property (nonatomic, readonly) NSDate *deadline;
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;



//设置倒计时截至时间
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setCountDownToDate:(NSDate*)date;

- (void)start;
- (void)pause;
- (void)reset;

@end
