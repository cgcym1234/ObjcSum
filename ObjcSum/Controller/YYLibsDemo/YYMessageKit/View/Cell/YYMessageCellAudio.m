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
    CGSize  contentSize = CGSizeMake(120, 20);
    return contentSize;
}
@end
