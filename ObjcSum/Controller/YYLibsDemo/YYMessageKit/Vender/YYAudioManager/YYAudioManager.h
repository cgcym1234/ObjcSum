//
//  YYAudioManager.h
//  ObjcSum
//
//  Created by sihuan on 16/3/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYAudioManager;

@protocol YYAudioManagerDelegate <NSObject>

@optional
#pragma mark - 播放

- (void)yyAudioManager:(YYAudioManager *)audioManager willBeginPlayingAudio:(NSURL *)audioURL;
- (void)yyAudioManager:(YYAudioManager *)audioManager didBeginPlayingAudio:(NSURL *)audioURL error:(NSError *)error;

- (void)yyAudioManager:(YYAudioManager *)audioManager didFinishPlayingAudio:(NSURL *)audioURL error:(NSError *)error;
/**
 *  播放音频被打断开始回调
 */
- (void)yyAudioManager:(YYAudioManager *)audioManager interruptedBeginWhenPlayingAudio:(NSURL *)audioURL;
/**
 *  播放音频被打断结束回调
 */
- (void)yyAudioManager:(YYAudioManager *)audioManager interruptedEndWhenPlayingAudio:(NSURL *)audioURL;

#pragma mark - 录制

- (void)yyAudioManager:(YYAudioManager *)audioManager willBeginRecordingAudio:(NSURL *)audioURL;
- (void)yyAudioManager:(YYAudioManager *)audioManager didBeginRecordingAudio:(NSURL *)audioURL error:(NSError *)error;

- (void)yyAudioManager:(YYAudioManager *)audioManager didFinishRecordingAudio:(NSURL *)audioURL error:(NSError *)error;
- (void)yyAudioManager:(YYAudioManager *)audioManager didCancelRecordingAudio:(NSURL *)audioURL;
/**
 *  录制音频被打断开始回调
 */
- (void)yyAudioManager:(YYAudioManager *)audioManager interruptedBeginWhenRecordingAudio:(NSURL *)audioURL;
/**
 *  录制音频被打断结束回调
 */
- (void)yyAudioManager:(YYAudioManager *)audioManager interruptedEndWhenRecordingAudio:(NSURL *)audioURL;



@end

@interface YYAudioManager : NSObject

@property (nonatomic, weak) id<YYAudioManagerDelegate> delegate;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) BOOL isRecording;

+ (instancetype)defaultManager;

/**
 *  播放音频文件
 *
 *  @discussion 开始播放，YYAudioManagerDelegate中的didBeginPlayingAudio回调会被触发，播放完成后, YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 *  @param audioURL 音频文件路径
 *  @param delegate YYAudioManagerDelegate
 */
- (void)playAudio:(NSURL *)audioURL
     delegate:(id<YYAudioManagerDelegate>)delegate;

/**
 *  停止播放音频
 *
 *  @discussion 音频播放完成后YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 */
- (void)stopPlaying;

- (void)pausePlaying;
- (void)resumePlaying;

/**
 *  开始录制音频
 *
 *  @discussion 开始录音，YYAudioManagerDelegate中的didBeginRecordingAudio:回调会被触发，录音完成后, YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 *  @param duration 最长录音时间
 *  @param delegate YYAudioManagerDelegate
 */

- (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioManagerDelegate>)delegate;

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


























