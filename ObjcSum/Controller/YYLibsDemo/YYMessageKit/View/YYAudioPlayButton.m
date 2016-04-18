//
//  YYAudioPlayButton.m
//  ObjcSum
//
//  Created by sihuan on 16/3/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYAudioPlayButton.h"
#import "YYAudioPlayer.h"
#import "YYMessageDefinition.h"



@interface YYAudioPlayButton ()<YYAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageMarginLeftToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageMarginRightToSuperView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelMarginLeftToImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelMarginRightToImage;
@end

@implementation YYAudioPlayButton

- (void)awakeFromNib {
    //    _voiceButton.layer.borderColor = ColorFromRGBHex(0xdddddd).CGColor;
    //    _voiceButton.layer.borderWidth = 1;
    //    _voiceButton.layer.cornerRadius = 16;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (IBAction)didTapView {
    if (_didTapBlock) {
        _didTapBlock(self);
    }
    [self play];
}

#pragma mark - Private

- (BOOL)_isAudioPlaying {
    return [[YYAudioPlayer sharedInstance] isPlaying];
}

- (void)_updatePlayingImage {
    NSString *prefix = _type == YYAudioPlayButtonTypeVoiceLeft ? @"ReceiverVoiceNodePlaying00":@"SenderVoiceNodePlaying00";
    if ([self _isAudioPlaying]) {
        _imageView.image = [UIImage animatedImageNamed:prefix duration:1.0];
    } else {
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@2", prefix]];
    }
}

#pragma mark - Public

- (void)setAudioURL:(NSURL *)audioURL duration:(NSInteger)duration {
    self.audioURL = audioURL;
    self.duration = duration;
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
    
    NSString *durationString = [@(ceil(duration/1000)) stringValue];
    [_textLabel setText:durationString != nil ? [durationString stringByAppendingString:@"''"] : nil];
}

- (void)setType:(YYAudioPlayButtonType)type {
    _type = type;
    
    //左边的配置
    UILayoutPriority marginLeftPriority = UILayoutPriorityRequired;
    UILayoutPriority marginRigthPriority = UILayoutPriorityDefaultHigh;
    UIColor *textColor = ColorFromRGBHex(0x000000);
    
    switch (type) {
        case YYAudioPlayButtonTypeVoiceLeft: {
            break;
        }
        case YYAudioPlayButtonTypeVoiceRight: {
            marginLeftPriority = UILayoutPriorityDefaultHigh;
            marginRigthPriority = UILayoutPriorityRequired;
            textColor = ColorFromRGBHex(0xffffff);
            break;
        }
    }
    _imageMarginLeftToSuperView.priority = marginLeftPriority;
    _imageMarginRightToSuperView.priority = marginRigthPriority;
    
    _labelMarginLeftToImage.priority = marginLeftPriority;
    _labelMarginRightToImage.priority = marginRigthPriority;
    _textLabel.textColor = textColor;
    
    [self _updatePlayingImage];
}

- (void)play {
    [YYAudioPlayer playAudio:_audioURL delegate:self];
//    [self _updatePlayingImage];
}

- (void)stopPlaying {
    [YYAudioPlayer stopPlaying];
//    [self _updatePlayingImage];
}

#pragma mark - Delegate

- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder willBeginPlaying:(NSURL *)audioURL error:(NSError *)error {
}
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didBeginPlaying:(NSURL *)audioURL {
    [self _updatePlayingImage];
}

- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didPausePlaying:(NSURL *)audioURL {
    [self _updatePlayingImage];
}
- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didResumePlaying:(NSURL *)audioURL {
    [self _updatePlayingImage];
}

- (void)yyAudioPlayer:(YYAudioPlayer *)audioRecorder didFinishPlaying:(NSURL *)audioURL error:(NSError *)error {
    [self _updatePlayingImage];
}


@end
