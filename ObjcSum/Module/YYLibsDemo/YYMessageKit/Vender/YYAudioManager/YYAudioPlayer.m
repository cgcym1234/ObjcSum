//
//  YYAudioPlayer.m
//  ObjcSum
//
//  Created by sihuan on 16/4/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYAudioPlayer.h"
#import "NSString+YYMessage.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - Const

//static NSInteger const HeightForCommonCell = 49;


@interface YYAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音

@end

@implementation YYAudioPlayer

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDelegate:nil];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)initWithDelegate:(id<YYAudioPlayerDelegate>)delegate {
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
    //播放时，设置时喇叭播放否则音量很小
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //启动音频会话管理,此时会阻断后台音乐的播放.
    [audioSession setActive:active error:nil];
}

- (void)playNewAudio:(NSURL *)audioURL {
    _audioPlayer = [self newAudioPlayerWithUrl:audioURL];
    if ([_audioPlayer prepareToPlay]) {
        [self setAudioSessionActive:YES];
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:willBeginPlaying:error:)]) {
            [_delegate yyAudioPlayer:self willBeginPlaying:_audioPlayer.url error:nil];
        }
        /*异步的 sound is played asynchronously. */
        [_audioPlayer play];
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:didBeginPlaying:)]) {
            [_delegate yyAudioPlayer:self didBeginPlaying:_audioPlayer.url];
        }
    }
}

#pragma mark - Public

- (BOOL)isPlaying {
    return _audioPlayer.isPlaying;
}

+ (void)playAudio:(NSURL *)audioURL delegate:(id<YYAudioPlayerDelegate>)delegate {
    [[YYAudioPlayer sharedInstance] playAudio:audioURL delegate:delegate];
}
+ (void)stopPlaying {
    [[YYAudioPlayer sharedInstance] stopPlaying];
}
+ (void)pausePlaying {
    [[YYAudioPlayer sharedInstance] pausePlaying];
}
+ (void)resumePlaying {
    [[YYAudioPlayer sharedInstance] resumePlaying];
}
/**
 *  播放音频文件
 *
 *  @discussion 开始播放，YYAudioManagerDelegate中的didBeginPlayingAudio回调会被触发，播放完成后, YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 *  @param audioURL 音频文件路径
 *  @param delegate YYAudioManagerDelegate
 */
- (void)playAudio:(NSURL *)audioURL delegate:(id<YYAudioPlayerDelegate>)delegate {
    /**
     判断当前与下一个是否相同
     相同时，暂停或恢复
     不相同时，停止播放当前的，开始播放下一个
     */
    BOOL isSame = [_audioPlayer.url.absoluteString isEqualToString:audioURL.absoluteString] ? true : false;
    
    if (isSame) {
        if (_audioPlayer.isPlaying) {
            [self pausePlaying];
        } else {
            [self resumePlaying];
        }
    } else {
        
        /**
         这里不能用_audioPlayer.isPlaying来判断
         因为播放一个新的之前，如果之前有个是暂停状态
         那么必须将之前的stop，否则会继续播放暂停的那个
         */
        if (_audioPlayer) {
//            _audioPlayer.isPlaying
            [self stopPlaying];
        }
        
        _delegate = delegate;
        [self playNewAudio:audioURL];
    }
}

/**
 *  停止播放音频
 *
 *  @discussion 音频播放完成后YYAudioManagerDelegate中的didFinishPlayingAudio:回调会被触发
 */
- (void)stopPlaying {
    [_audioPlayer stop];
    //stop不会触发audioPlayerDidFinishPlaying回调
    if ([_delegate respondsToSelector:@selector(yyAudioPlayer:didFinishPlaying:error:)]) {
        [_delegate yyAudioPlayer:self didFinishPlaying:_audioPlayer.url error:nil];
    }
    _audioPlayer = nil;
    if (_audioPlayer.isPlaying) {
        
    }
}

- (void)pausePlaying {
    if (_audioPlayer.isPlaying) {
        [_audioPlayer pause];
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:didPausePlaying:)]) {
            [_delegate yyAudioPlayer:self didPausePlaying:_audioPlayer.url];
        }
    }
}

- (void)resumePlaying {
    if (!_audioPlayer.isPlaying) {
        [self setAudioSessionActive:YES];
        [_audioPlayer play];
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:didResumePlaying:)]) {
            [_delegate yyAudioPlayer:self didResumePlaying:_audioPlayer.url];
        }
    }
}

#pragma mark - Delegate

#pragma mark AVAudioSessionInterruptionNotification

- (void)handleInterruption:(NSNotification *)notification {
    if (!self.isPlaying) {
        return;
    }
    
    NSDictionary *interruptionDictionary = [notification userInfo];
    AVAudioSessionInterruptionType type =
    [interruptionDictionary [AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"Interruption started");
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:interruptedBeginWhenPlaying:)]) {
            [_delegate yyAudioPlayer:self interruptedBeginWhenPlaying:_audioPlayer.url];
        }
        [self pausePlaying];
    } else if (type == AVAudioSessionInterruptionTypeEnded){
        NSLog(@"Interruption ended");
        if ([_delegate respondsToSelector:@selector(yyAudioPlayer:interruptedEndWhenPlaying:)]) {
            [_delegate yyAudioPlayer:self interruptedEndWhenPlaying:_audioPlayer.url];
        }
        [self resumePlaying];
    } else {
        NSLog(@"Something else happened");
    }
}

#pragma mark 
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
//    [self setAudioSessionActive:NO];
    if (flag) {
        NSLog(@"播放成功! path: %@", player.url);
    }
    if ([_delegate respondsToSelector:@selector(yyAudioPlayer:didFinishPlaying:error:)]) {
        [_delegate yyAudioPlayer:self didFinishPlaying:player.url error:nil];
    }
    _audioPlayer = nil;//释放
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [self setAudioSessionActive:NO];
    if ([self.delegate respondsToSelector:@selector(yyAudioPlayer:didFinishPlaying:error:)]) {
        [self.delegate yyAudioPlayer:self didFinishPlaying:player.url error:error];
    }
    NSLog(@"audioPlayerDecodeErrorDidOccur，错误信息：%@",error.localizedDescription);
}



#pragma mark - Setter


#pragma mark - Getter

- (NSURL *)audioUrl {
    return _audioPlayer.url;
}

-(AVAudioPlayer *)newAudioPlayerWithUrl:(NSURL *)url{
    if (!_audioPlayer) {
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            if ([_delegate respondsToSelector:@selector(yyAudioPlayer:willBeginPlaying:error:)]) {
                [_delegate yyAudioPlayer:self willBeginPlaying:url error:error];
            }
            return nil;
        }
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}



@end
