//
//  YYMessageCellImage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageCellImage.h"
#import "UIImage+YYMessage.h"
#import "YYMessageModel.h"
#import "YYMessageObjectImage.h"

@implementation YYMessageCellImage

#pragma mark - Overrider

- (void)setContext {
    [super setContext];
    [self.bubbleContainerView addSubview:self.messageImageView];
    self.bubbleSubViewCustomer = self.messageImageView;
}

- (void)renderWithMessageModel:(YYMessageModel *)messageModel atIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView {
    [super renderWithMessageModel:messageModel atIndexPath:indexPath inCollectionView:collectionView];
    
    /**
     *  使用缩略小图
     */
    YYMessageObjectImage *imageObject = messageModel.message.messageObject;
    UIImage *image = [UIImage imageByNameOrPath:imageObject.thumbPath];
    [_messageImageView setImage:image];
}

#pragma mark - Getter

- (YYMessageImageView *)messageImageView {
    if (!_messageImageView) {
        YYMessageImageView *imageView = [YYMessageImageView new];
        _messageImageView = imageView;
    }
    return _messageImageView;
}

#pragma mark - YYMessageCellLayoutConfig

+ (CGSize)contentSize:(YYMessageModel *)model cellWidth:(CGFloat)cellWidth {
    CGSize  contentSize = [YYMessageCellConfig defaultConfig].attachmentImageSizeMin;
    YYMessageObjectImage *imageObject = model.message.messageObject;
    if (!CGSizeEqualToSize(imageObject.size, CGSizeZero))
    {
        contentSize = [UIImage sizeProperlyFromOrigin:imageObject.size
                                                  min:[YYMessageCellConfig defaultConfig].attachmentImageSizeMin
                                                  max:[YYMessageCellConfig defaultConfig].attachmentImageSizeMax];
    }
    return contentSize;
}

@end
