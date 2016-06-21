//
//  YYRefreshView.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYRefreshView.h"
#import "YYRefreshConst.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@interface YYRefreshView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YYRefreshView


#pragma mark - Initialization

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


- (void)setContext {
    [self addSubview:self.textLabel];
    [self addSubview:self.imageView];
}


#pragma mark - Override

- (void)layoutSubviews {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _textLabel.center = center;
    
    center.x -= CGRectGetMidX(_textLabel.bounds) + CGRectGetMidX(_imageView.bounds) + 5;
    _imageView.center = center;
    [super layoutSubviews];
}

#pragma mark - Private


#pragma mark - Public

- (void)showIdleWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
    
    void (^action)(void) = ^{
        _imageView.transform = CGAffineTransformIdentity;
        _textLabel.text = config.textIdle;
    };
    
    if (animated) {
        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
    } else {
        action();
    }
}
- (void)showRedayWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
    
    void (^action)(void) = ^{
        _imageView.transform = CGAffineTransformRotate(_imageView.transform, DegreesToRadians(180.1));
        _textLabel.text = config.textReady;
    };
    
    if (animated) {
        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
    } else {
        action();
    }
}

- (void)showRefreshingWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
    void (^action)(void) = ^{
        _textLabel.text = config.textRefreshing;
    };
    
    if (animated) {
        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
    } else {
        action();
    }
}

#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = YYRefreshLabelFont;
        label.textColor = YYRefreshLabelTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.backgroundColor = [UIColor clearColor];
        label.text = YYRefreshIdleText;
        [label sizeToFit];
        _textLabel = label;
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.bounds = CGRectMake(0, 0, 16, 16);
        _imageView = imageView;
    }
    return _imageView;
}



@end