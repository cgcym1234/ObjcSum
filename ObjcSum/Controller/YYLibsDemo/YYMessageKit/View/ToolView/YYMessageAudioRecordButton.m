//
//  YYMessageAudioRecordButton.m
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageAudioRecordButton.h"
#import "YYMessageAudioIndicatorView.h"
#import "YYAudioManager.h"

@interface YYMessageAudioRecordButton ()
<YYAudioManagerDelegate>

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, assign) YYMessageAudioRecordButtonState  recordState;

@end

@implementation YYMessageAudioRecordButton

#pragma mark - Initialization

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
    
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
}


#pragma mark - Override


#pragma mark - Private

/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (IBAction)touchDown:(UIButton *)sender {
    self.recordState = YYMessageAudioRecordButtonStateTouchDown;
}

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (IBAction)touchUpInside:(UIButton *)sender {
    self.recordState = YYMessageAudioRecordButtonStateTouchUpInside;
}

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (IBAction)touchUpOutside:(UIButton *)sender {
    self.recordState = YYMessageAudioRecordButtonStateTouchUpOutside;
}

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (IBAction)touchDragOutside:(UIButton *)sender {
    self.recordState = YYMessageAudioRecordButtonStateTouchDragOutside;
}

/**
 *  当手指滑动到录音按钮的范围之内所触发的事件
 */
- (IBAction)touchDragInside:(UIButton *)sender {
    self.recordState = YYMessageAudioRecordButtonStateTouchDragInside;
}

#pragma mark - Public


#pragma mark - Delegate

- (void)yyAudioManager:(YYAudioManager *)audioManager didFinishRecordingAudio:(NSURL *)audioURL error:(NSError *)error {
    if (error) {
        return;
    }
    
    if (_completeBlock) {
        _completeBlock(self, audioURL);
    }
}

#pragma mark - Setter

- (void)setRecordState:(YYMessageAudioRecordButtonState)recordState {
    switch (recordState) {
        case YYMessageAudioRecordButtonStateTouchDown: {
            NSLog(@"YYMessageAudioRecordButtonStateTouchDown");
            [YYMessageAudioIndicatorView show];
            [[YYAudioManager defaultManager] recordForDuration:60 delegate:self];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchUpInside: {
            [YYMessageAudioIndicatorView dismiss];
            [[YYAudioManager defaultManager] stopRecording];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchUpOutside: {
            [YYMessageAudioIndicatorView dismiss];
            [[YYAudioManager defaultManager] cancelRecording];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchDragOutside: {
            [YYMessageAudioIndicatorView setState:YYMessageAudioIndicatorViewStateCanceling];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchDragInside: {
            [YYMessageAudioIndicatorView setState:YYMessageAudioIndicatorViewStateRecording];
            break;
        }
    }
}

#pragma mark - Getter



@end
