//
//  YYAudioPlayButton.m
//  ObjcSum
//
//  Created by sihuan on 16/3/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYAudioPlayButton.h"
#import "YYAudioManager.h"

@interface YYAudioPlayButton ()<YYAudioManagerDelegate>

@end

@implementation YYAudioPlayButton

- (void)awakeFromNib {
    self.showDeleteButton = NO;
//    _voiceButton.layer.borderColor = ColorFromRGBHex(0xdddddd).CGColor;
//    _voiceButton.layer.borderWidth = 1;
//    _voiceButton.layer.cornerRadius = 16;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (IBAction)voiceButtonDidClicked:(UIButton *)sender {
    if (_didClickBlock) {
        _didClickBlock(self, YYAudioPlayButtonActionTypePlay);
    }
    [self play];
}

- (IBAction)deleteButtonDidClicked:(UIButton *)sender {
//    if (self.filePath.absoluteString) {
//        [[NSFileManager defaultManager] removeItemAtPath:self.filePath.absoluteString error:nil];
//    }
    
    if (_didClickBlock) {
        _didClickBlock(self, YYAudioPlayButtonActionTypeDelete);
    }
}

#pragma mark - Public

- (void)setAudioURL:(NSURL *)audioURL duration:(NSInteger)duration {
    self.audioURL = audioURL;
    self.duration = duration;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton {
    _showDeleteButton = showDeleteButton;
    _deleteButton.hidden = !showDeleteButton;
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
    
    NSString *durationString = [@(ceil(duration/1000)) stringValue];
    [_voiceButton setTitle:durationString != nil ? [durationString stringByAppendingString:@"''"] : nil forState:UIControlStateNormal];
}

- (void)play {
    [[YYAudioManager defaultManager] playAudio:_audioURL delegate:self];
}

- (void)stopPlaying {
    [[YYAudioManager defaultManager] stopPlaying];
}

#pragma mark - Delegate

- (void)yyAudioManager:(YYAudioManager *)audioManager didFinishPlayingAudio:(NSURL *)audioURL error:(NSError *)error {
    
}


@end
