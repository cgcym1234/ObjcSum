//
//  FastRecordVoiceInputView.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordVoiceInputView.h"
//#import "MLLVoiceRecorderManager.h"
#import "MBProgressHUD.h"
#import "YYHud.h"


@implementation FastRecordVoiceInputView


/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (IBAction)touchDown:(UIButton *)sender {
    self.isCancelled = NO;
    self.isRecording = NO;
    
//    NSUUID *uuid = [NSUUID UUID];
//    __weak typeof(self) weakSelf = self;
//    if ([[MLLVoiceRecorderManager sharedManager] prepareToRecord:uuid.UUIDString]) {
////        [[MLLVoiceRecorderManager sharedManager] setMicroPhoneMeterChangeObsever:^(float meter) {
////            ///进度监控
////        }];
//        [YYHud showTip:@"录音开始" duration:1];
//        weakSelf.isRecording = YES;
//        [[MLLVoiceRecorderManager sharedManager] startRecordWithDurtion:63 completionHandler:^(NSURL *filePath, NSError *error) {
//            weakSelf.isRecording = NO;
//            if (filePath && !error) {
//                NSTimeInterval duration = [[MLLVoiceRecorderManager sharedManager] audioDurationInFile:filePath.absoluteString];
////                NSLog(@"duration %f", duration);
//                if (duration >= 1.0) {
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //隐藏 HUD view
//
//                        if (duration >= 58.0) {
//                            [YYHud showTip:@"录音已超时" duration:1];
//                        }
//                        
//                        //录音成功，发送路径
//                        if (weakSelf.didCompletedBlock) {
//                            weakSelf.didCompletedBlock(weakSelf, filePath, duration);
//                        }
//                        NSLog(@"completionHandler %@", filePath);
//
//                    });
//                }
//                else
//                {
//                    //时间少于1秒
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [YYHud showTip:@"录音时间太短" duration:1];
//                    });
//                }
//            }
//        }];
//    }
}

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (IBAction)touchUpOutside:(UIButton *)sender {
    [YYHud showTip:@"录音失败" duration:1];
    if (self.isRecording) {
//        [[MLLVoiceRecorderManager sharedManager] cancelRecord];
        self.isRecording = NO;
        self.isCancelled = YES;
    } else {
        self.isCancelled = YES;
    }
    
}

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (IBAction)touchUpInside:(UIButton *)sender {
    if (self.isRecording) {
//        [[MLLVoiceRecorderManager sharedManager] stopRecord];
        self.isRecording = NO;
    } else {
        self.isCancelled = YES;
    }
}

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (IBAction)dragOutside:(UIButton *)sender {

}

/**
 *  当手指滑动到录音按钮的范围之内所触发的事件
 */
- (IBAction)dragInside:(UIButton *)sender {
    
}


#pragma mark - Public
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FastRecordVoiceInputView *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FastRecordVoiceInputView instanceFromNib];
    });
    return sharedInstance;
}


@end
