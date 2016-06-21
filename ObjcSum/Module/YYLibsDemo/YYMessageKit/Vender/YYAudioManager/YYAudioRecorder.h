//
//  YYAudioRecorder.h
//  ObjcSum
//
//  Created by sihuan on 16/4/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYAudioRecorder;

@protocol YYAudioRecorderDelegate <NSObject>

@optional
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder willBeginRecording:(NSURL *)audioURL error:(NSError *)error;
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didBeginRecording:(NSURL *)audioURL;

- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didFinishRecording:(NSURL *)audioURL error:(NSError *)error;
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder didCancelRecording:(NSURL *)audioURL;

/**
 *  录制音频被打断开始回调
 */
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder interruptedBeginWhenRecording:(NSURL *)audioURL;
/**
 *  录制音频被打断结束回调
 */
- (void)yyAudioRecorder:(YYAudioRecorder *)audioRecorder interruptedEndWhenRecording:(NSURL *)audioURL;

@end

@interface YYAudioRecorder : NSObject

@property (nonatomic, weak) id<YYAudioRecorderDelegate> delegate;
@property (nonatomic, readonly) BOOL isRecording;
@property (nonatomic, readonly) NSURL *audioUrl;

+ (instancetype)sharedInstance;
+ (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioRecorderDelegate>)delegate;
+ (void)stopRecording;
+ (void)cancelRecording;


- (instancetype)initWithDelegate:(id<YYAudioRecorderDelegate>)delegate;
/**
 *  开始录制音频
 *
 *  @discussion 开始录音，YYAudioManagerDelegate中的didBeginRecordingAudio:回调会被触发，录音完成后, YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 *  @param duration 最长录音时间
 *  @param delegate YYAudioManagerDelegate
 */

- (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioRecorderDelegate>)delegate;

/**
 *  停止录制音频
 *
 *  @discussion 停止录音后YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 */
- (void)stopRecording;

/**
 *  取消录制音频
 *
 *  @discussion 录音取消后，YYAudioManagerDelegate中的didCancelRecordingAudio回调会被触发
 */
- (void)cancelRecording;

@end
