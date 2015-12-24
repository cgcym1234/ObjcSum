//
//  UIViewController+NoDataView.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "UIViewController+NoDataView.h"
#import <objc/runtime.h>

static char NoDataViewKey;

@implementation UIViewController (NoDataView)

- (YYNoDataView *)noDataViewShow {
    return [self noDataViewShow:nil image:nil superView:self.view];
}

- (YYNoDataView *)noDataViewShow:(NSString *)content image:(UIImage *)image {
    return [self noDataViewShow:content image:image superView:self.view];
}

- (YYNoDataView *)noDataViewShow:(NSString *)content image:(UIImage *)image superView:(UIView *)superView {
    return [self noDataViewShow:content image:image buttonTitle:nil buttonBlock:nil superView:superView];
}

- (YYNoDataView *)noDataViewShow:(NSString *)content
                           image:(UIImage *)image
                     buttonTitle:(NSString *)buttonTitle
                     buttonBlock:(void(^)())buttonBlock
                       superView:(UIView *)superView {
    YYNoDataView *view = objc_getAssociatedObject(self, &NoDataViewKey);
    if (!view) {
        view = [[YYNoDataView alloc] init];
        objc_setAssociatedObject(self, &NoDataViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    [view update:content image:image buttonTitle:buttonTitle buttonBlock:buttonBlock];
    return view;
}

- (void)noDataViewDismiss {
    YYNoDataView *view = objc_getAssociatedObject(self, &NoDataViewKey);
    if (!view) {
        return;
    }
    [view removeFromSuperview];
    
    objc_setAssociatedObject(self, &NoDataViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
