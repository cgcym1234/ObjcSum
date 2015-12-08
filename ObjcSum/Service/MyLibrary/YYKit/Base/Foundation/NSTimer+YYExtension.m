//
//  NSTimer+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSTimer+YYExtension.h"
#import <objc/runtime.h>

@implementation NSTimer (YYExtension)

+ (void)_yy_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}
/**
 Creates and returns a new NSTimer object and schedules it on the current run
 loop in the default mode.
 
 @discussion     After seconds seconds have elapsed, the timer fires,
 sending the message aSelector to target.
 
 @param seconds  The number of seconds between firings of the timer. If seconds
 is less than or equal to 0.0, this method chooses the
 nonnegative value of 0.1 milliseconds instead.
 
 @param block    The block to invoke when the timer fires. The timer  maintains
 a strong reference to the block until it (the timer) is invalidated.
 
 @param repeats  If YES, the timer will repeatedly reschedule itself until
 invalidated. If NO, the timer will be invalidated after it fires.
 
 @return A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)yy_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_yy_ExecBlock:) userInfo:block repeats:repeats];
}

/**
 Creates and returns a new NSTimer object initialized with the specified block.
 
 @discussion      You must add the new timer to a run loop, using addTimer:forMode:.
 Then, after seconds have elapsed, the timer fires, invoking
 block. (If the timer is configured to repeat, there is no need
 to subsequently re-add the timer to the run loop.)
 
 @param seconds  The number of seconds between firings of the timer. If seconds
 is less than or equal to 0.0, this method chooses the
 nonnegative value of 0.1 milliseconds instead.
 
 @param block    The block to invoke when the timer fires. The timer instructs
 the block to maintain a strong reference to its arguments.
 
 @param repeats  If YES, the timer will repeatedly reschedule itself until
 invalidated. If NO, the timer will be invalidated after it fires.
 
 @return A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)yy_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_yy_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

static NSString *const NSTimerPauseDate = @"NSTimerPauseDate";
static NSString *const NSTimerPreviousFireDate = @"NSTimerPreviousFireDate";

-(void)yy_pauseTimer {
    objc_setAssociatedObject(self, (__bridge const void *)(NSTimerPauseDate), [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)(NSTimerPreviousFireDate), self.fireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.fireDate = [NSDate distantFuture];
}

-(void)yy_resumeTimer {
    
    NSDate *pauseDate = objc_getAssociatedObject(self, (__bridge const void *)NSTimerPauseDate);
    NSDate *previousFireDate = objc_getAssociatedObject(self, (__bridge const void *)NSTimerPreviousFireDate);
    
    const NSTimeInterval pauseTime = -[pauseDate timeIntervalSinceNow];
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate];
}

@end
