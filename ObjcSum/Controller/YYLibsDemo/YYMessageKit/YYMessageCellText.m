//
//  YYMessageCellText.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageCellText.h"
#import "YYMessageModel.h"

@implementation YYMessageCellText

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _messageTextLabel.origin = CGPointMake(self.cellConfig.bubbleViewInsets.left, self.cellConfig.bubbleViewInsets.top);
    _messageTextLabel.size = self.messageModel.contentSize;
}

- (void)setContext {
    [super setContext];
    [self.bubbleContainerView addSubview:self.messageTextLabel];
}

- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView {
    [super renderWithMessageModel:messageModel atIndexPath:indexPath inCollectionView:collectionView];
    _messageTextLabel.text = messageModel.message.text;
}

#pragma mark - YYMessageCellLayoutConfig

+ (CGSize)contentSize:(YYMessageModel *)model cellWidth:(CGFloat)width {
    YYMessageCellConfig *cellConfig = [YYMessageCellConfig defaultConfig];
    CGFloat textMaxWidth = width - (cellConfig.avatarImageViewWH
                                    + cellConfig.contentViewInsets.left
                                    + cellConfig.contentViewInsets.right
                                    + cellConfig.bubbleViewInsets.left
                                    + cellConfig.bubbleViewInsets.right);
    
    YYMessageTextLabel *textLabel = cellConfig.messageTextLabel;
    textLabel.text = model.message.text;
    CGSize contentSize = [textLabel sizeThatFits:CGSizeMake(textMaxWidth, CGFLOAT_MAX)];
    return contentSize;
}

#pragma mark - Private

- (UILabel *)messageTextLabel {
    if (!_messageTextLabel) {
        _messageTextLabel = [[YYMessageCellConfig defaultConfig].messageTextLabel cloneLabel];
    }
    return _messageTextLabel;
}



@end
