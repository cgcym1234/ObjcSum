//
//  JMGoodsDtailRightBarButtonView.m
//  JuMei
//
//  Created by yangyuan on 2016/11/10.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDtailRightBarButtonView.h"
#import "UIView+Frame.h"

#pragma mark - Const

static NSInteger const ButtonSize = 30;


@interface JMGoodsDtailRightBarButtonView ()


@end

@implementation JMGoodsDtailRightBarButtonView


#pragma mark - Initialization

- (void)setupContext {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.likeButton];
    [self addSubview:self.shareButton];
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private


#pragma mark - Public

- (void)updateWithProduct {
    BOOL showShareButton = NO;

    BOOL showLikeButton = YES;
    

    
    _likeButton.hidden = !showLikeButton;
    _shareButton.hidden = !showShareButton;
    
    //都放到最右边
    _likeButton.right = self.width;
    _shareButton.right = self.width;
    
    //_likeButton移动到最左边
    if (showLikeButton && showShareButton) {
        _likeButton.left = 0;
    }
}

#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

//- (JMGoodsDetailLickButton *)likeButton {
//    if (!_likeButton) {
//        JMGoodsDetailLickButton *likeButton = [JMGoodsDetailLickButton instanceWithProduct:nil];
//        likeButton.size = CGSizeMake(ButtonSize, ButtonSize);
//        likeButton.hidden = YES;
//        _likeButton = likeButton;
//    }
//    return _likeButton;
//}
//
//- (JMGoodsDetailShareButton *)shareButton {
//    if (!_shareButton) {
//        JMGoodsDetailShareButton *shareButton = [JMGoodsDetailShareButton instanceWithViewController:self.containerViewController];
//        shareButton.size = CGSizeMake(ButtonSize, ButtonSize);
//        shareButton.hidden = YES;
//        _shareButton = shareButton;
//    }
//    return _shareButton;
//}


@end

