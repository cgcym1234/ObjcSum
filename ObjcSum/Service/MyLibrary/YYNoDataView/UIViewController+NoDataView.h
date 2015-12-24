//
//  UIViewController+NoDataView.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYNoDataView.h"

@interface UIViewController (NoDataView)

- (YYNoDataView *)noDataViewShow;
- (YYNoDataView *)noDataViewShow:(NSString *)content image:(UIImage *)image;
- (YYNoDataView *)noDataViewShow:(NSString *)content image:(UIImage *)image superView:(UIView *)superView;

- (YYNoDataView *)noDataViewShow:(NSString *)content
                           image:(UIImage *)image
                     buttonTitle:(NSString *)buttonTitle
                     buttonBlock:(void(^)())buttonBlock
                       superView:(UIView *)superView;

- (void)noDataViewDismiss;

@end
