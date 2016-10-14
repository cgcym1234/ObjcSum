//
//  YYChrysanthemum.m
//  ObjcSum
//
//  Created by sihuan on 15/12/16.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYChrysanthemum.h"

@implementation YYChrysanthemum

#pragma mark - Private

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
    _indicatorView.center = self.center;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = NO;
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}


#pragma mark - Pulbic

- (void)show {
    return [self showInView:[UIApplication sharedApplication].keyWindow wrapInteraction:NO dim:NO];
}

- (void)showInView:(UIView *)superView {
    return [self showInView:superView wrapInteraction:NO dim:NO];
}

- (void)showInView:(UIView *)superView wrapInteraction:(BOOL)wrapInteraction dim:(BOOL)dim  {
    self.backgroundColor = dim ? [UIColor blackColor] : [UIColor clearColor];
    self.userInteractionEnabled = wrapInteraction;
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    [superView addSubview:self];
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
}

- (void)dismiss {
    [_indicatorView stopAnimating];
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
