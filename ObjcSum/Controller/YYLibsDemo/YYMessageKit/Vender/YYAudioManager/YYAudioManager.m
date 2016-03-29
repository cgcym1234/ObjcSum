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
@property (nonatomic, strong) NSMutableDictionary *audioRecorderSetting; // 录音设置

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
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    return self;
}

#pragma mark - Public

#pragma mark Play
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
        self.audioPlayer = nil;
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

#pragma mark Record

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
            //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
            [self.audioRecorder record];
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
    self.audioRecorder = nil;
}


#pragma mark - Override


#pragma mark - Private


- (void)resetAudioPlayer {
    _audioPlayer = nil;
    [self resumePlaying];
}


#pragma mark - Delegate

#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    self.isPlaying = NO;
    self.audioPlayer = nil;
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

#pragma mark - AVAudioRecorderDelegate
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    self.audioRecorder = nil;
    self.isRecording = NO;
    if (flag) {
        
    }
    if ([self.delegate respondsToSelector:@selector(yyAudioManager:didFinishRecordingAudio:error:)]) {
        [self.delegate yyAudioManager:self didFinishRecordingAudio:recorder.url error:nil];
    }
    NSLog(@"录音完成! path: %@", recorder.url);
}


// 录音音量显示
- (void)detectionVoice
{
    // 刷新音量数据
    [self.audioRecorder updateMeters];
    // 获取音量的平均值  [recorder averagePowerForChannel:0];
    // 音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:0]));
    // NSLog(@"%lf",lowPassResults);
    // 最大50  0
    // 图片 小-》大
    if (0 < lowPassResults <= 0.06)
    {
    }
    else if (0.06 < lowPassResults <= 0.13)
    {
    }
    else if (0.13 < lowPassResults <= 0.20)
    {
    }
    else if (0.20 < lowPassResults <= 0.27)
    {
    }
    else if (0.27 < lowPassResults <= 0.34)
    {
    }
    else if (0.34 < lowPassResults <= 0.41)
    {
    }
    else if (0.41 < lowPassResults <= 0.48)
    {
    }
    else if (0.48 < lowPassResults <= 0.55)
    {
    }
    else if (0.55 < lowPassResults <= 0.62)
    {
    }
    else if (0.62 < lowPassResults <= 0.69)
    {
    }
    else if (0.69 < lowPassResults <= 0.76)
    {
    }
    else if (0.76 < lowPassResults <= 0.83)
    {
    }
    else if (0.83 < lowPassResults <= 0.9)
    {
    }
    else
    {
    }
}

#pragma mark - Setter

- (void)setAudioURL:(NSURL *)audioURL {
    // 判断当前与下一个是否相同
    // 相同时，点击时要么播放，要么停止
    // 不相同时，点击时停止播放当前的，开始播放下一个
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

- (NSMutableDictionary *)audioRecorderSetting {
    if (!_audioRecorderSetting) {
        // 参数设置 格式、采样率、录音通道、线性采样位数、录音质量
        _audioRecorderSetting = [NSMutableDictionary dictionaryWithDictionary:[self getAudioSetting]];
    }
    return _audioRecorderSetting;
}

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
             
             
             AVEncoderAudioQualityKey:@(AVAudioQualityHigh),
             };
}


- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        NSLog(@"audioRecorder");
        //创建录音文件保存路径
        NSString *audioPath = [NSString directoryForVoiceByCurrentTimestamp];
        
#warning 注意这里audioName不能自己加后缀.amr .mp3等
        /**
         *  注意这里audioName如果加上后缀.amr 或.mp3
         *  创建audioRecorder会报错 NSOSStatusErrorDomain 1718449215
         但是加.wav和.caf可以。。。
         */
        NSString *audioName = [NSString stringWithFormat:@"%ld.caf", (long)[NSDate date].timeIntervalSince1970*1000*1000 ];
        NSURL *url = [NSURL fileURLWithPath:[audioPath stringByAppendingPathComponent:audioName]];
        
        NSError *error;
        AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.audioRecorderSetting error:&error];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        audioRecorder.delegate = self;
        //如果要监控声波则必须设置为YES
        audioRecorder.meteringEnabled = YES;
        
        // 录音时设置audioSession属性，否则不兼容Ios7
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [recordSession setActive:YES error:nil];
        
        
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
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        _audioPlayer.delegate = self;
        
        // 播放时，设置时喇叭播放否则音量很小
        AVAudioSession *playSession = [AVAudioSession sharedInstance];
        [playSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [playSession setActive:YES error:nil];
    }
    return _audioPlayer;
}


@end






