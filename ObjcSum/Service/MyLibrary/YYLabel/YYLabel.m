//
//  YYLabel.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYLabel.h"

IB_DESIGNABLE
@implementation YYLabel

#pragma mark - IBDesignable

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
        self.layer.masksToBounds = YES;
    }
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

#pragma mark UIEdgeInsets

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)) {
        _contentEdgeInsets = contentEdgeInsets;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setInsetTop:(CGFloat)insetTop {
    if (_insetTop != insetTop) {
        _insetTop = insetTop;
        [self updateContentInsetsWithTop:insetTop left:0 bottom:0 right:0];
    }
}

- (void)setInsetLeft:(CGFloat)insetLeft {
    if (_insetLeft != insetLeft) {
        _insetLeft = insetLeft;
        [self updateContentInsetsWithTop:0 left:insetLeft bottom:0 right:0];
    }
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    if (_insetBottom != insetBottom) {
        _insetBottom = insetBottom;
        [self updateContentInsetsWithTop:0 left:0 bottom:insetBottom right:0];
    }
}

- (void)setInsetRight:(CGFloat)insetRight {
    if (_insetRight != insetRight) {
        _insetRight = insetRight;
        [self updateContentInsetsWithTop:0 left:0 bottom:0 right:insetRight];
    }
}

#pragma mark - Private

- (void)updateContentInsetsWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    CGFloat finalTop = top > 0 ? top : _contentEdgeInsets.top;
    CGFloat finalLeft = left > 0 ? left : _contentEdgeInsets.left;
    CGFloat finalBottom = bottom > 0 ? bottom : _contentEdgeInsets.bottom;
    CGFloat finalRight = right > 0 ? right : _contentEdgeInsets.right;
    self.contentEdgeInsets = UIEdgeInsetsMake(finalTop, finalLeft, finalBottom, finalRight);
}

#pragma mark - Override

//如果不覆盖drawTextInRect方法，那么需要设置居中
- (CGSize)intrinsicContentSize {
    CGSize contentSize = [super intrinsicContentSize];
    if (CGSizeEqualToSize(contentSize, CGSizeZero) || UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, UIEdgeInsetsZero)) {
        return contentSize;
    }
    return CGSizeMake(_contentEdgeInsets.left + contentSize.width + _contentEdgeInsets.right, _contentEdgeInsets.top + contentSize.height + _contentEdgeInsets.bottom);
}

//需要和intrinsicContentSize配合使用
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentEdgeInsets)];
}

@end
