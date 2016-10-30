//
//  UIButton+YYSDK.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIButton+YYSDK.h"
#import "UIImage+YYSDK.h"

@implementation UIButton (YYSDK)

#pragma mark - 调整文字和图片位置

- (void)setImagePosition:(YYButtonImagePosition)postion spacing:(CGFloat)space {
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat imageViewHeight = CGRectGetHeight(self.imageView.frame);
    // 由于iOS8中titleLabel的size为0，需要用intrinsicContentSize
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    CGFloat buttonHeight = CGRectGetHeight(self.bounds);
    CGFloat overHeight = (imageViewHeight + labelHeight - buttonHeight) / 2;

    if (labelWidth == 0) {
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        labelWidth  = titleSize.width;
    }
    
    CGFloat imageInsetsTop = 0.0f;
    CGFloat imageInsetsLeft = 0.0f;
    CGFloat imageInsetsBottom = 0.0f;
    CGFloat imageInsetsRight = 0.0f;
    
    CGFloat titleInsetsTop = 0.0f;
    CGFloat titleInsetsLeft = 0.0f;
    CGFloat titleInsetsBottom = 0.0f;
    CGFloat titleInsetsRight = 0.0f;
    
    CGFloat contentInsetsTop = 0.0f;
    CGFloat contentInsetsLeft = 0.0f;
    CGFloat contentInsetsBottom = 0.0f;
    CGFloat contentInsetsRight = 0.0f;
    
    switch (postion) {
        case YYButtonImagePositionRight: {
            space = space * 0.5;
            
            imageInsetsLeft = labelWidth + space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = - (imageViewWidth + space);
            titleInsetsRight = -titleInsetsLeft;
            
            contentInsetsLeft = space;
            contentInsetsRight = space;
            overHeight = 0;
            break;
        }
        case YYButtonImagePositionLeft: {
            space = space * 0.5;
            
            imageInsetsLeft = -space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = space;
            titleInsetsRight = -titleInsetsLeft;
            
            contentInsetsLeft = space;
            contentInsetsRight = space;
            overHeight = 0;
            break;
        }
            
        case YYButtonImagePositionBottom: {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
            
            imageInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - imageBottomY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
            
            contentInsetsTop = space / 2;
            contentInsetsBottom = space / 2;
            break;
        }
        case YYButtonImagePositionTop: {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
            
            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
            
            contentInsetsTop = space / 2;
            contentInsetsBottom = space / 2;
            break;
        }
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
    
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    self.contentEdgeInsets = UIEdgeInsetsMake(contentEdgeInsets.top + contentInsetsTop + overHeight, contentEdgeInsets.left + contentInsetsLeft, contentEdgeInsets.bottom + contentInsetsBottom + overHeight, contentEdgeInsets.right + contentInsetsRight);
}

#pragma mark - Title

- (void)setTitleAll:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
}
- (void)setTitleNormal:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleHighlighted:(NSString *)title {
    [self setTitle:title forState:UIControlStateHighlighted];
}
- (void)setTitleDisabled:(NSString *)title {
    [self setTitle:title forState:UIControlStateDisabled];
}
- (void)setTitleSelected:(NSString *)title {
    [self setTitle:title forState:UIControlStateSelected];
}

- (NSString *)titleNomal {
    return [self titleForState:UIControlStateNormal];
}
- (NSString *)titleHighlighted {
    return [self titleForState:UIControlStateHighlighted];
}
- (NSString *)titleDisabled {
    return [self titleForState:UIControlStateDisabled];
}
- (NSString *)titleSelected {
    return [self titleForState:UIControlStateSelected];
}

#pragma mark - 设置背景色

- (void)setBackgroundColorNomal:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
}
- (void)setBackgroundColorHighlighted:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateHighlighted];
}
- (void)setBackgroundColorDisabled:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateDisabled];
}
- (void)setBackgroundColorSelected:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected];
}
@end




















