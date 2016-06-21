//
//  YYMessageAudioIndicatorView.m
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageAudioIndicatorView.h"
#import "UIView+YYMessage.h"
#import "YYDim.h"


static CGFloat const CountDownInterval = 0.1;
static NSString * const TextRecording = @"手指上滑，取消发送";
static NSString * const TextCanceling = @"松开手指，取消发送";


@interface YYMessageAudioIndicatorView ()

@property (nonatomic, assign) CGFloat seconds;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YYMessageAudioIndicatorView


#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self newInstanceFromNib];
    });
    return sharedInstance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}


- (void)setContext {
//    self.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - Override


#pragma mark - Private

- (void)countdownBegin {
    self.seconds = 0.00;
    self.state = YYMessageAudioIndicatorViewStateRecording;
    [self countdownEnd];
    self.timer.fireDate = [NSDate distantPast];
    [self.timer fire];
    
}

- (void)updateTime {
    self.seconds += CountDownInterval;
    NSLog(@"%lf",_seconds);
    if (_seconds >= 60) {
        [self.class dismiss];
    }
}

- (void)countdownEnd {
//    self.seconds = 0;
    self.timer.fireDate = [NSDate distantFuture];
}



#pragma mark - Public

+ (void)show {
    [YYDim showView:[self sharedInstance] animation:YYDimAnimationNone options:YYDimOpitionNone];
    [[self sharedInstance] countdownBegin];
}

+ (void)dismiss {
    [[self sharedInstance] countdownEnd];
    [YYDim dismss];
}

+ (void)setState:(YYMessageAudioIndicatorViewState)state {
    [[self sharedInstance] setState:state];
}

#pragma mark - Setter

- (void)setSeconds:(CGFloat)seconds {
    _seconds = seconds;
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = [NSString stringWithFormat:@"%02.1fs", seconds];
    });
}

- (void)setState:(YYMessageAudioIndicatorViewState)state {
    _state = state;
    switch (state) {
        case YYMessageAudioIndicatorViewStateRecording: {
            _textLabel.text = TextRecording;
            _textLabel.backgroundColor = [UIColor clearColor];
            break;
        }
        case YYMessageAudioIndicatorViewStateCanceling: {
            _textLabel.text = TextCanceling;
            _textLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.183 blue:0.169 alpha:1.000];
            break;
        }
    }
}

#pragma mark - Getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:CountDownInterval target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

@end


