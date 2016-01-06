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

- (void)setContext {
    [super setContext];
    [self.bubbleContainerView addSubview:self.messageTextLabel];
    self.bubbleSubViewCustomer = self.messageTextLabel;
}

- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView {
    [super renderWithMessageModel:messageModel atIndexPath:indexPath inCollectionView:collectionView];
    _messageTextLabel.text = messageModel.message.text;
    _messageTextLabel.textColor = messageModel.message.isOutgoing ? self.cellConfig.messageTextColorOutgoing : self.cellConfig.messageTextColorIncoming;
}

#pragma mark - YYMessageCellLayoutConfig

+ (CGSize)contentSize:(YYMessageModel *)model cellWidth:(CGFloat)width {
    YYMessageCellConfig *cellConfig = [YYMessageCellConfig defaultConfig];
    CGFloat textMaxWidth = width - (cellConfig.avatarImageViewWH
                                    + cellConfig.bubbleArrowWith
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

- (YYMessageTextLabel *)messageTextLabel {
    if (!_messageTextLabel) {
        _messageTextLabel = [[YYMessageCellConfig defaultConfig].messageTextLabel clone];
    }
    return _messageTextLabel;
}



@end
