//
//  YYXibView.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYXibView.h"

@implementation YYXibView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (_xibContentView == nil && newSuperview != nil) {
        [self loadXibView];
    }
}

- (void)loadXibView {
    UIView *xibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    if (!xibView) {
        return;
    }
    xibView.backgroundColor = [UIColor clearColor];
    xibView.translatesAutoresizingMaskIntoConstraints = YES;
    xibView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    xibView.frame = self.bounds;
    [self addSubview:xibView];
    _xibContentView = xibView;
}

@end
