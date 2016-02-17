//
//  YYMessageModel.m
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageModel.h"
#import "YYMessage.h"
#import "YYMessageCellText.h"
#import "YYMessageCellImage.h"

@interface YYMessageModel ()

@property (nonatomic, readwrite) NSString *cellIdentifier;
@property (nonatomic, readwrite) UIEdgeInsets  contentViewInsets;
@property (nonatomic, readwrite) UIEdgeInsets  bubbleViewInsets;
@property (nonatomic, readwrite) BOOL shouldShowAvatar;
@property (nonatomic, readwrite) BOOL shouldShowNickName;

@property (nonatomic, weak) Class<YYMessageCellLayoutConfig> cellLayoutDelegate;
@end

@implementation YYMessageModel

#pragma mark - Public

- (instancetype)initWithMessage:(YYMessage*)message {
    if (self = [self init]) {
        self.message = message;
    }
    return self;
}
+ (instancetype)modelWithMessage:(YYMessage*)message {
    return [[YYMessageModel alloc] initWithMessage:message];
}

- (void)setMessage:(YYMessage *)message {
    _message = message;
    switch (message.messageType) {
        case YYMessageTypeText:
            _cellLayoutDelegate = [YYMessageCellText class];
            _cellIdentifier = [YYMessageCellText identifier];
            break;
        case YYMessageTypeImage:
            _cellLayoutDelegate = [YYMessageCellImage class];
            _cellIdentifier = [YYMessageCellImage identifier];
            break;
            
        default:
            break;
    }
    _shouldShowNickName = YES;
}

#pragma mark - Public

- (void)calculateSizeInWidth:(CGFloat)width {
    if (CGSizeEqualToSize(_contentSize, CGSizeZero)) {
        _contentSize = [_cellLayoutDelegate contentSize:self cellWidth:width];
        _cellHeight = [self calculateCellHeight];
    }
}

/**
 *  清除缓存的布局数据，contentSize，cellHeight
 */
- (void)cleanCacheLayout {
    _contentSize = CGSizeZero;
    _cellHeight = 0;
}

#pragma mark - Private

- (CGFloat)calculateCellHeight {
    YYMessageCellConfig *cellConfig = [YYMessageCellConfig defaultConfig];
    
    CGFloat cellTopLabelHeight = _displaySendTime ? cellConfig.cellTopLabelHeight : 0;
    CGFloat bubbleTopLabelHeight = cellConfig.bubbleTopLabelShow && _shouldShowNickName ? cellConfig.bubbleTopLabelHeight : 0;
    CGFloat cellBottomLabelHeight = cellConfig.cellBottomLabelShow && _shouldShowNickName ? cellConfig.cellBottomLabelHeight : 0;
    
    UIEdgeInsets contentViewInsets = cellConfig.contentViewInsets;
    UIEdgeInsets bubbleViewInsets  = cellConfig.bubbleViewInsets;
    
    CGFloat bubbleHeight = bubbleTopLabelHeight + _contentSize.height + bubbleViewInsets.top + bubbleViewInsets.bottom;
    
    //头像高度和气泡高度取较大的值
    CGFloat cellHeight = MAX(bubbleHeight, cellConfig.avatarImageViewWH) + cellTopLabelHeight +  cellBottomLabelHeight  + contentViewInsets.top + contentViewInsets.bottom;
    return cellHeight;
}

@end
