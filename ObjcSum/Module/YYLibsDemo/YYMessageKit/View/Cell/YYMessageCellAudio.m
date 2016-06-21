//
//  YYMessageCellAudio.m
//  ObjcSum
//
//  Created by sihuan on 16/3/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageCellAudio.h"
#import "YYAudioPlayButton.h"
#import "YYMessageObjectAudio.h"

@implementation YYMessageCellAudio

#pragma mark - Overrider

- (void)setContext {
    [super setContext];
    [self.bubbleContainerView addSubview:self.audioPlayButton];
    self.bubbleSubViewCustomer = self.audioPlayButton;
}

- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView {
    [super renderWithMessageModel:messageModel atIndexPath:indexPath inCollectionView:collectionView];
    YYMessageObjectAudio *audioObject = messageModel.message.messageObject;
    
    _audioPlayButton.type = messageModel.message.isOutgoing ? YYAudioPlayButtonTypeVoiceRight : YYAudioPlayButtonTypeVoiceLeft;
    [_audioPlayButton setAudioURL:audioObject.locolURL duration:audioObject.duration];
}

#pragma mark - Getter

- (YYAudioPlayButton *)audioPlayButton {
    if (!_audioPlayButton) {
        YYAudioPlayButton *audioPlayButton = [YYAudioPlayButton newInstanceFromNib];
        audioPlayButton.translatesAutoresizingMaskIntoConstraints = YES;
        _audioPlayButton = audioPlayButton;
    }
    return _audioPlayButton;
}

#pragma mark - YYMessageCellLayoutConfig

+ (CGSize)contentSize:(YYMessageModel *)model cellWidth:(CGFloat)cellWidth {
    YYMessageObjectAudio *audioObject = model.message.messageObject;
    NSInteger duration = audioObject.duration/1000;
    CGFloat width = 40 + MIN(duration/30.0, 1) * 200 ;
    CGSize  contentSize = CGSizeMake(width, 24);
    return contentSize;
}
@end
