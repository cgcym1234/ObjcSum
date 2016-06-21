//
//  YYMessageCellBase.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageCellBase.h"
#import "YYMessageModel.h"


@implementation YYMessageCellBase

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    CGFloat cellWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat x = _cellConfig.contentViewInsets.left;
    CGFloat labeWidth = cellWidth - (_cellConfig.contentViewInsets.left+_cellConfig.contentViewInsets.right);
    
    _cellTopLabel.frame = CGRectMake(x, _cellConfig.contentViewInsets.top, labeWidth, _cellTopLabel.height);
    
    //气泡上面label位置
    _bubbleTopLabel.y = _cellTopLabel.bottom;
    _bubbleTopLabel.width = labeWidth - _avatarImageView.width;
    
    _bubbleContainerView.y = _bubbleTopLabel.bottom;
    _bubbleContainerView.size = CGSizeMake(
                                           _cellConfig.bubbleArrowWith +
                                           _messageModel.contentSize.width + _cellConfig.bubbleViewInsets.left + _cellConfig.bubbleViewInsets.right,
                                           _messageModel.contentSize.height + _cellConfig.bubbleViewInsets.top +_cellConfig.bubbleViewInsets.bottom);
    
    _bubbleSubViewCustomer.size = _messageModel.contentSize;
    _bubbleSubViewCustomer.top = _cellConfig.bubbleViewInsets.top;
    //头像上下位置设置
    if (_cellConfig.avatarImageViewShowAtTop) {
        _avatarImageView.y = _cellTopLabel.bottom;
    } else {
        _avatarImageView.bottom = _bubbleContainerView.bottom;
    }
    
    //发出去的消息位置
    if (_messageModel.message.isOutgoing) {
        _avatarImageView.right = cellWidth - _cellConfig.contentViewInsets.right;
        _bubbleTopLabel.right = _avatarImageView.left;
        _bubbleContainerView.right = _avatarImageView.left;
        _bubbleSubViewCustomer.left = _cellConfig.bubbleViewInsets.left;
    } else {
        _avatarImageView.left = _cellConfig.contentViewInsets.left;
        _bubbleTopLabel.left = _avatarImageView.right;
        _bubbleContainerView.left = _avatarImageView.right;
        
        //根据气泡箭头方向，动态调整左右间距
        _bubbleSubViewCustomer.right = _bubbleContainerView.width - _cellConfig.bubbleViewInsets.left;
    }
    
    _cellBottomLabel.frame = CGRectMake(x,
                                     _bubbleContainerView.bottom,
                                     labeWidth,
                                     _cellBottomLabel.height);
    [super layoutSubviews];
}

#pragma mark - Public

/**
 *  cell的唯一标志符
 */
+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView {
    _messageModel = messageModel;
    _indexPath = [indexPath copy];
    _collectionView = collectionView;
    
    _bubbleContainerView.isOutgoing = messageModel.message.isOutgoing;
    [self setCellTopLabelText:messageModel.displaySendTime];
    [self setBubbleTopLabelText:messageModel.message.senderName];
    [self setCellBottomLabelText:messageModel.message.senderName];
}

#pragma mark - Private

- (void)setContext {
    _cellConfig = [YYMessageCellConfig defaultConfig];
    
    [self.contentView addSubview:self.cellTopLabel];
    [self.contentView addSubview:self.bubbleTopLabel];
    
    [self.contentView addSubview:self.avatarImageView];
    //    [self.bubbleContainerView addSubview:self.bubbleImageView];
    [self.contentView addSubview:self.bubbleContainerView];
    
    [self.contentView addSubview:self.cellBottomLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Getters and Setters

- (void)setCellTopLabelText:(NSString *)text {
    _cellTopLabel.text = text;
    _cellTopLabel.height = text.length > 0 ? _cellConfig.cellTopLabelHeight : 0;
}
- (void)setBubbleTopLabelText:(NSString *)text {
    if (_cellConfig.bubbleTopLabelShow) {
        _bubbleTopLabel.text = text;
        _bubbleTopLabel.height = text.length > 0 && _messageModel.shouldShowNickName ? _cellConfig.bubbleTopLabelHeight : 0;
        _bubbleTopLabel.textAlignment = _messageModel.message.isOutgoing ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }
}
- (void)setCellBottomLabelText:(NSString *)text {
    if (_cellConfig.cellBottomLabelShow) {
        _cellBottomLabel.text = text;
        _cellBottomLabel.height = text.length > 0 && _messageModel.shouldShowNickName ? _cellConfig.cellBottomLabelHeight : 0;
        _cellBottomLabel.textAlignment = _messageModel.message.isOutgoing ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }
}

- (UILabel *)cellTopLabel {
    if (!_cellTopLabel) {
        _cellTopLabel = [UILabel labelAlignmentCenter];
        _cellTopLabel.font = _cellConfig.cellTopLabelFont;
        _cellTopLabel.textColor = _cellConfig.cellTopLabelColor;
    }
    return _cellTopLabel;
}

- (UILabel *)bubbleTopLabel {
    if (!_bubbleTopLabel) {
        _bubbleTopLabel = [UILabel labelAlignmentCenter];
        _bubbleTopLabel.font = _cellConfig.bubbleTopLabelFont;
        _bubbleTopLabel.textColor = _cellConfig.bubbleTopLabelColor;
    }
    return _bubbleTopLabel;
}

- (UILabel *)cellBottomLabel {
    if (!_cellBottomLabel) {
        _cellBottomLabel = [UILabel labelAlignmentCenter];
        _cellBottomLabel.font = _cellConfig.cellBottomLabelFont;
        _cellBottomLabel.textColor = _cellConfig.cellBottomLabelColor;
    }
    return _cellBottomLabel;
}

- (YYMessageAvatarView *)avatarImageView {
    if (!_avatarImageView) {
        YYMessageAvatarView *avatarView = [YYMessageAvatarView new];
        avatarView.bounds = CGRectMake(0, 0, _cellConfig.avatarImageViewWH, _cellConfig.avatarImageViewWH);
//        avatarView.contentMode = UIViewContentModeScaleAspectFit;
//        avatarView.round = YES;
        _avatarImageView = avatarView;
        _avatarImageView.image = [UIImage imageNamed:@"ChatWindow_DefaultAvatar"];
        MacroWeakSelf(weakSelf);
        avatarView.touchUpInsideBlock = ^(YYMessageAvatarView *view) {
            [weakSelf.delegate yyMessageCellBase:weakSelf didClickItem:YYMessageItemAvatar atIndexPath:[weakSelf.collectionView indexPathForCell:weakSelf] withMessageModel:weakSelf.messageModel];
        };
    }
    return _avatarImageView;
}

- (UIView *)bubbleContainerView {
    if (!_bubbleContainerView) {
        _bubbleContainerView = [YYMessageBubbleView new];
        _bubbleContainerView.backgroundColor = [UIColor clearColor];
    }
    return _bubbleContainerView;
}

//- (UIImageView *)bubbleImageView {
//    if (!_bubbleImageView) {
//        UIImageView *imageView = [UIImageView new];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _bubbleImageView = imageView;
//        _bubbleImageView.origin = CGPointZero;
//    }
//    return _bubbleImageView;
//}


@end
