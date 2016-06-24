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

@interface YYRefreshView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *refreshingView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *currentText;

@end

@implementation YYRefreshView


#pragma mark - Initialization

- (instancetype)initWithConfig:(YYRefreshConfig *)config postion:(YYRefreshPosition)postion {
    if (self = [super init]) {
        switch (postion) {
            case YYRefreshPositionBottom:
            case YYRefreshPositionLeft:
                self.imageView.image = [UIImage imageNamed:YYRefreshImageUp];
                break;
            case YYRefreshPositionTop:
            case YYRefreshPositionRight:
                self.imageView.image = [UIImage imageNamed:YYRefreshImageDown];
                break;
        }
        self.textLabel.text = config.textIdle;
        [self setContext];
    }
    return self;
}


- (void)setContext {
    [self addSubview:self.textLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.refreshingView];
}


#pragma mark - Override

- (void)layoutSubviews {
    [self updateLocation];
    [super layoutSubviews];
}

- (void)updateLocation {
    [_textLabel sizeToFit];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _textLabel.center = center;
    
    center.x -= CGRectGetMidX(_textLabel.bounds) + CGRectGetMidX(_imageView.bounds) + 5;
    _imageView.center = center;
    _refreshingView.center = center;
}

#pragma mark - Private


#pragma mark - Public

- (void)showIdleWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
    void (^action)(void) = ^{
        _imageView.transform = CGAffineTransformIdentity;
    };
    
    if (animated) {
        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
    } else {
        action();
    }
    
    [_refreshingView stopAnimating];
    _imageView.hidden = NO;
    self.currentText = config.textIdle;
}

- (void)showRedayWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
    
    void (^action)(void) = ^{
        _imageView.transform = CGAffineTransformRotate(_imageView.transform, DegreesToRadians(180.1));
    };
    
    if (animated) {
        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
    } else {
        action();
    }
    self.currentText = config.textReady;
}

- (void)showRefreshingWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated {
//    void (^action)(void) = ^{
//        _textLabel.text = config.textRefreshing;
//    };
//    
//    if (animated) {
//        [UIView animateWithDuration:YYRefreshSlowAnimationDuration animations:action completion:nil];
//    } else {
//        action();
//    }
    [_refreshingView startAnimating];
    _imageView.hidden = YES;
    self.currentText = config.textRefreshing;
}

#pragma mark - Setter

- (void)setCurrentText:(NSString *)currentText {
    _currentText = currentText;
    _textLabel.text = currentText;
    [_textLabel sizeToFit];
    [self layoutIfNeeded];
}

#pragma mark - Getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = YYRefreshLabelFont;
        label.textColor = YYRefreshLabelTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = YYRefreshIdleText;
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

- (UIActivityIndicatorView *)refreshingView {
    if (!_refreshingView) {
        UIActivityIndicatorView *refreshingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshingView.hidesWhenStopped = YES;
        _refreshingView = refreshingView;
    }
    return _refreshingView;
}


@end