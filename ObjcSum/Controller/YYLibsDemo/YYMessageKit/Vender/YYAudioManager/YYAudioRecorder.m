//
//  YYAudioRecorder.m
//  ObjcSum
//
//  Created by sihuan on 16/4/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYAudioRecorder.h"
#import "NSString+YYMessage.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - Const

//static NSInteger const HeightForCommonCell = 49;


@interface YYAudioRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic, strong) NSMutableDictionary *audioRecorderSetting; // 录音设置
@property (nonatomic, assign) BOOL isCanceled;


@end

@implementation YYAudioRecorder

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDelegate:nil];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)initWithDelegate:(id<YYAudioRecorderDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        [self setContext];
    }
    return self;
}

- (void)setContext {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:        AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override


#pragma mark - Private

- (void)setAudioSessionActive:(BOOL)active {
    // 录音时设置audioSession属性，否则不兼容Ios7
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置为录音状态
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    //启动音频会话管理,此时会阻断后台音乐的播放.
    [audioSession setActive:active error:nil];
}

#pragma mark - Public

- (BOOL)isRecording {
    return _audioRecorder.isRecording;
}

+ (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioRecorderDelegate>)delegate {
    [[YYAudioRecorder sharedInstance] recordForDuration:duration delegate:delegate];
}
+ (void)stopRecording {
    [[YYAudioRecorder sharedInstance] stopRecording];
}
+ (void)cancelRecording {
    [[YYAudioRecorder sharedInstance] cancelRecording];
}

/**
 *  开始录制音频
 *
 *  @discussion 开始录音，YYAudioManagerDelegate中的didBeginRecordingAudio:回调会被触发，录音完成后, YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 *  @param duration 最长录音时间
 *  @param delegate YYAudioManagerDelegate
 */

- (void)recordForDuration:(NSTimeInterval)duration delegate:(id<YYAudioRecorderDelegate>)delegate {
    _delegate = delegate;
    if (!_audioRecorder.isRecording) {
        _audioRecorder = [self newAudioRecorder];
        
        if ([_audioRecorder prepareToRecord]) {
            [self setAudioSessionActive:YES];
//            [_audioRecorder recordForDuration:duration];
            if ([self.delegate respondsToSelector:@selector(yyAudioRecorder:willBeginRecording:error:)]) {
                [self.delegate yyAudioRecorder:self willBeginRecording:_audioRecorder.url error:nil];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
                [_audioRecorder recordForDuration:duration];
            });
            if ([self.delegate respondsToSelector:@selector(yyAudioRecorder:didBeginRecording:)]) {
                [self.delegate yyAudioRecorder:self didBeginRecording:_audioRecorder.url];
            }
        }
    }
}

/**
 *  停止录制音频
 *
 *  @discussion 停止录音后YYAudioManagerDelegate中的didFinishRecordingAudio:回调会被触发
 */
- (void)stopRecording {
    if (_audioRecorder.isRecording) {
        [_audioRecorder stop];
    }
}

/**
 *  取消录制音频
 *
 *  @discussion 录音取消后，YYAudioManagerDelegate中的didCancelRecordingAudio回调会被触发
 */
- (void)cancelRecording {
    if (_audioRecorder.isRecording) {
        _isCanceled = YES;
        /**
         *  stop会触发audioRecorderDidFinishRecording
         所以需要一个额外判断取消的标记
         */
        [_audioRecorder stop];
    }
}

#pragma mark - Delegate

#pragma mark AVAudioSessionInterruptionNotification

- (void)handleInterruption:(NSNotification *)notification {
    if (!self.isRecording) {
        return;
    }
    
    NSDictionary *interruptionDictionary = [notification userInfo];
    AVAudioSessionInterruptionType type =
    [interruptionDictionary [AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"Interruption started");
        if ([_delegate respondsToSelector:@selector(yyAudioRecorder:interruptedBeginWhenRecording:)]) {
            [_delegate yyAudioRecorder:self interruptedBeginWhenRecording:_audioRecorder.url];
        }
        [self cancelRecording];
    } else if (type == AVAudioSessionInterruptionTypeEnded){
        NSLog(@"Interruption ended");
        if ([_delegate respondsToSelector:@selector(yyAudioRecorder:interruptedBeginWhenRecording:)]) {
            [_delegate yyAudioRecorder:self interruptedBeginWhenRecording:_audioRecorder.url];
        }
    } else {
        NSLog(@"Something else happened");
    }
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [self setAudioSessionActive:NO];
    if (_isCanceled) {
        _isCanceled = NO;
        if ([_delegate respondsToSelector:@selector(yyAudioRecorder:didCancelRecording:)]) {
            [_delegate yyAudioRecorder:self didCancelRecording:recorder.url];
        }
        //取消就删除文件
        if ([_audioRecorder deleteRecording]) {
            
        }
    } else {
        if (flag) {
            NSLog(@"录音成功! path: %@", recorder.url);
        }
        if ([self.delegate respondsToSelector:@selector(yyAudioRecorder:didFinishRecording:error:)]) {
            [self.delegate yyAudioRecorder:self didFinishRecording:recorder.url error:nil];
        }
    }
    _audioRecorder = nil;//释放
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [self setAudioSessionActive:NO];
    if ([self.delegate respondsToSelector:@selector(yyAudioRecorder:didFinishRecording:error:)]) {
        [self.delegate yyAudioRecorder:self didFinishRecording:recorder.url error:error];
    }
    NSLog(@"audioRecorderEncodeErrorDidOccur，错误信息：%@",error.localizedDescription);
}

#pragma mark - Setter


#pragma mark - Getter

- (NSURL *)audioUrl {
    return _audioRecorder.url;
}

- (AVAudioRecorder *)newAudioRecorder {
    //创建录音文件保存路径
    NSString *audioPath = [NSString directoryForVoiceByCurrentTimestamp];
    NSString *audioName = [NSString stringWithFormat:@"%ld.wav", (long)[NSDate date].timeIntervalSince1970*1000*1000 ];
    NSURL *url = [NSURL fileURLWithPath:[audioPath stringByAppendingPathComponent:audioName]];
    NSError *error;
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.audioRecorderSetting error:&error];
    if (error) {
        if ([self.delegate respondsToSelector:@selector(yyAudioRecorder:willBeginRecording:error:)]) {
            [self.delegate yyAudioRecorder:self willBeginRecording:url error:error];
        }
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    audioRecorder.delegate = self;
    //如果要监控声波则必须设置为YES
    audioRecorder.meteringEnabled = YES;
    
    return audioRecorder;
}

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
             
             //大端还是小端 是内存的组织方式
//             AVLinearPCMIsBigEndianKey:@(YES),
             
             //每个采样点位数,分为8、16、24、32
             AVLinearPCMBitDepthKey:@(8),
             
             //是否使用浮点数采样
//             AVLinearPCMIsFloatKey:@(YES),
             
             AVEncoderAudioQualityKey:@(AVAudioQualityHigh),
             };
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

@end