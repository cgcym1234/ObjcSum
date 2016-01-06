//
//  YYMessageBubbleView.m
//  ObjcSum
//
//  Created by sihuan on 16/1/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageBubbleView.h"
#import "YYMessageCellLayoutConfig.h"
#import "UIImage+YYMessage.h"
#import "UIColor+YYMessage.h"

@interface YYMessageBubbleView ()

@property (nonatomic, strong) UIImageView *bubbleImageView;
@end

@implementation YYMessageBubbleView

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

- (void)layoutSubviews {
    _bubbleImageView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)setContext {
    [self addSubview:self.bubbleImageView];
}

- (UIImageView *)bubbleImageView {
    if (!_bubbleImageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleToFill;
        _bubbleImageView = imageView;
    }
    return _bubbleImageView;
}

#pragma mark - Public

- (void)setIsOutgoing:(BOOL)isOutgoing {
    _isOutgoing = isOutgoing;
    [self yy_setBubbleImageView:isOutgoing];
}

#pragma mark - Private

- (void )yy_setBubbleImageView:(BOOL)isOutgoing {
    UIColor *color = isOutgoing ? [YYMessageCellConfig defaultConfig].bubbleColorOutgoing : [YYMessageCellConfig defaultConfig].bubbleColorIncoming;
    
    UIImage *bubbleImage = [UIImage bubbleRegularImage];
    
    UIImage *normalBubble = [bubbleImage imageMaskedWithColor:color];
    UIImage *highlightBubble = [bubbleImage imageMaskedWithColor:[color colorByDarkeningColorWithValue:0.16]];
    
    if (!isOutgoing) {
        normalBubble = [normalBubble imageHorizontallyFlipped];
        highlightBubble = [highlightBubble imageHorizontallyFlipped];
    }
    _bubbleImageView.image = [normalBubble imageStretchabledFromCenterPointEdgeInsets];
    _bubbleImageView.highlightedImage = [highlightBubble imageStretchabledFromCenterPointEdgeInsets];
}


@end
