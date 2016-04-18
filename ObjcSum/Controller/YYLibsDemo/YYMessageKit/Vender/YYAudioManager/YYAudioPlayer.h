//
//  YYAudioPlayer.h
//  ObjcSum
//
//  Created by sihuan on 16/4/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYAudioPlayer;

@protocol YYAudioPlayerDelegate <NSObject>

@optional
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder willBeginPlaying:(NSURL *)audioURL error:(NSError *)error;
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didBeginPlaying:(NSURL *)audioURL;

- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didPausePlaying:(NSURL *)audioURL;
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didResumePlaying:(NSURL *)audioURL;

- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didFinishPlaying:(NSURL *)audioURL error:(NSError *)error;
/**
 *  播放音频被打断开始回调
 */
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder interruptedBeginWhenPlaying:(NSURL *)audioURL;
/**
 *  播放音频被打断结束回调
 */
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder interruptedEndWhenPlaying:(NSURL *)audioURL;

@end

@interface YYAudioPlayer : NSObject

@property (nonatomic, weak) id<YYAudioPlayerDelegate> delegate;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) NSURL *audioUrl;

+ (instancetype)sharedInstance;
+ (void)playAudio:(NSURL *)audioURL delegate:(id<YYAudioPlayerDelegate>)delegate;
+ (void)stopPlaying;
+ (void)pausePlaying;
+ (void)resumePlaying;

- (instancetype)initWithDelegate:(id<YYAudioPlayerDelegate>)delegate;
/**
 *  播放音频文件
 *
 *  @discussion 开始播放，YYAudioManagerDelegate中的didBeginPlayingAudio回调会被触发，播放完成后, YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 *  @param audioURL 音频文件路径
 *  @param delegate YYAudioManagerDelegate
 */
- (void)playAudio:(NSURL *)audioURL delegate:(id<YYAudioPlayerDelegate>)delegate;

/**
 *  停止播放音频
 *
 *  @discussion 音频播放完成后YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 */
- (void)stopPlaying;
- (void)pausePlaying;
- (void)resumePlaying;

@end


