//
//  YYMessageAudioRecordButton.m
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageAudioRecordButton.h"
#import "YYMessageAudioIndicatorView.h"
#import "YYAudioRecorder.h"

@interface YYMessageAudioRecordButton ()
<YYAudioRecorderDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, assign) YYMessageAudioRecordButtonState  recordState;
@property (nonatomic, assign) BOOL isRocording;
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
    #pragma mark - 通过添加一个tap，完美解决因为系统滑动返回手势对touchDown的影响
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDown:)];
    tap.delaysTouchesBegan = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
//    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    
    NSString *title = @"按住 说话";
    [self setTitle:title forState:UIControlStateNormal];
}


#pragma mark - Override

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    [self touchDown:self];
//    [super touchesBegan:touches withEvent:event];
//}

#pragma mark - Private

/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (IBAction)touchDown:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.recordState = YYMessageAudioRecordButtonStateTouchDown;
}

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (IBAction)touchUpInside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.recordState = YYMessageAudioRecordButtonStateTouchUpInside;
}

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (IBAction)touchUpOutside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.recordState = YYMessageAudioRecordButtonStateTouchUpOutside;
}

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (IBAction)touchDragOutside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.recordState = YYMessageAudioRecordButtonStateTouchDragOutside;
}

/**
 *  当手指滑动到录音按钮的范围之内所触发的事件
 */
- (IBAction)touchDragInside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.recordState = YYMessageAudioRecordButtonStateTouchDragInside;
}

#pragma mark - Public


#pragma mark - Delegate

- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder willBeginRecording:(NSURL *)audioURL error:(NSError *)error {
    
}
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didBeginRecording:(NSURL *)audioURL {
    
}

- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didFinishRecording:(NSURL *)audioURL error:(NSError *)error {
    if (error) {
        return;
    }
    
    if (_completeBlock) {
        _completeBlock(self, audioURL);
    }
}
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didCancelRecording:(NSURL *)audioURL {
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self touchDown:self];
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Setter

- (void)setIsRocording:(BOOL)isRocording {
    _isRocording = isRocording;
    self.backgroundColor = isRocording ? [UIColor lightGrayColor] : [UIColor whiteColor];
    NSString *title = isRocording ? @"松开 结束" : @"按住 说话";
    [self setTitle:title forState:UIControlStateNormal];
    if (isRocording) {
        [YYMessageAudioIndicatorView show];
    } else {
        [YYMessageAudioIndicatorView dismiss];
    }
}

- (void)setRecordState:(YYMessageAudioRecordButtonState)recordState {
    if (_recordState == recordState) {
        return;
    }
    switch (recordState) {
        case YYMessageAudioRecordButtonStateTouchDown: {
            self.isRocording = YES;
            [YYAudioRecorder recordForDuration:60 delegate:self];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchUpInside: {
            self.isRocording = NO;
            [YYAudioRecorder stopRecording];
            break;
        }
        case YYMessageAudioRecordButtonStateTouchUpOutside: {
            self.isRocording = NO;
            [YYAudioRecorder cancelRecording];
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
