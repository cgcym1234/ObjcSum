//
//  YYAudioManager.m
//  ObjcSum
//
//  Created by sihuan on 16/3/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYAudioManager.h"
#import "NSString+YYMessage.h"
#import <AVFoundation/AVFoundation.h>

@interface YYAudioManager ()<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音
@property (nonatomic, copy) NSURL *audioURL;

@end

@implementation YYAudioManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        _isPlaying = _isRecording = NO;
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    return self;
}

/**
 *  播放音频文件
 *
 *  @discussion 开始播放，YYAudioManagerDelegate中的didBeginPlayingAudio回调会被触发，播放完成后, YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 *  @param audioURL 音频文件路径
 *  @param delegate YYAudioManagerDelegate
 */
- (void)playAudio:(NSURL *)audioURL
         delegate:(id<YYAudioManagerDelegate>)delegate {
    self.audioURL = audioURL;
    self.delegate = delegate;
}

/**
 *  停止播放音频
 *
 *  @discussion 音频播放完成后YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 */
- (void)stopPlaying {
    if (_isPlaying) {
        [self.audioPlayer stop];
        self.isPlaying = NO;
    }
}

- (void)pausePlaying {
    if (_isPlaying) {
        [self.audioPlayer pause];
        self.isPlaying = NO;
    }
}
- (void)resumePlaying {
    if (!_isPlaying) {
        [self.audioPlayer play];
        self.isPlaying = YES;
    }
}

/**
 *  开始录制音频
 *
 *  @discussion 开始录音，YYAudioManagerDelegate中的didBeginRecordingAudio:回调会被触发，录音完成后, YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 *  @param duration 最长录音时间
 *  @param delegate YYAudioManagerDelegate
 */

- (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioManagerDelegate>)delegate {
    if (![self.audioRecorder isRecording]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
            self.delegate = delegate;
        });
        
    }
}

/**
 *  停止录制音频
 *
 *  @discussion 停止录音后YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 */
- (void)stopRecording {
    [self.audioRecorder stop];
}

/**
 *  取消录制音频
 *
 *  @discussion 录音取消后，YYAudioManagerDelegate中的didCancelRecordingAudio回调会被触发
 */
- (void)cancelRecording {
    [self.audioRecorder stop];
}


#pragma mark - Override


#pragma mark - Private

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting {
    return @{
             //设置录音格式
             AVFormatIDKey:@(kAudioFormatLinearPCM),
             
             //设置录音采样率，8000是电话采样率，对于一般录音已经够了
             AVSampleRateKey:@(8000),
             
             //设置通道,这里采用单声道
             AVNumberOfChannelsKey:@(1),
             
             //每个采样点位数,分为8、16、24、32
             AVLinearPCMBitDepthKey:@(8),
             
             //是否使用浮点数采样
             AVLinearPCMIsFloatKey:@(YES),
             };
}

- (void)resetAudioPlayer {
    _audioPlayer = nil;
    [self resumePlaying];
}

#pragma mark - Public


#pragma mark - Delegate

#pragma mark - 播放器代理方法

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    self.isPlaying = NO;
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    _audioRecorder = nil;
    if (flag) {
        
    }
    if ([self.delegate respondsToSelector:@selector(yyAudioManager:didFinishRecordingAudio:error:)]) {
        [self.delegate yyAudioManager:self didFinishRecordingAudio:recorder.url error:nil];
    }
    
//    _audioURL = recorder.url;
//    [self resetAudioPlayer];
    
    //    NSLog(@"录音完成! path: %@", recorder.url);
}

#pragma mark - Setter

- (void)setAudioURL:(NSURL *)audioURL {
    if (_isPlaying) {
        [self stopPlaying];
        if ([_audioURL.absoluteString isEqualToString:audioURL.absoluteString]) {
            return;
        }
    }
    _audioURL = audioURL;
    [self resetAudioPlayer];
}

#pragma mark - Getter

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        NSLog(@"audioRecorder");
        //创建录音文件保存路径
        NSString *audioPath = [NSString directoryForImageByCurrentTimestamp];
        NSString *audioName = [NSString stringWithFormat:@"%f.amr", [NSDate date].timeIntervalSince1970];
        
        NSURL *url = [NSURL fileURLWithPath:[audioPath stringByAppendingPathComponent:audioName]];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        NSError *error;
        AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        audioRecorder.delegate = self;
        //如果要监控声波则必须设置为YES
        audioRecorder.meteringEnabled = YES;
        _audioRecorder = audioRecorder;
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:_audioURL error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        _audioPlayer.delegate = self;
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}


@end






