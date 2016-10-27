//
//  YYXibView.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYXibView.h"

@implementation YYXibView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadXibView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadXibView];
    }
    return self;
}

- (void)loadXibView {
    UIView *xibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    if (!xibView) {
        return;
    }
    xibView.backgroundColor = [UIColor clearColor];
    xibView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:xibView];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:xibView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:xibView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:xibView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:xibView.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:xibView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:xibView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:xibView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:xibView.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [xibView.superview addConstraints:@[top, left, bottom, right]];
    
    _xibContentView = xibView;
}

@end
