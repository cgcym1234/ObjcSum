//
//  YYChrysanthemum.h
//  ObjcSum
//
//  Created by sihuan on 15/12/16.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYChrysanthemum : UIView

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

//+ (instancetype)show;
//+ (instancetype)showInView:(UIView *)superView;
//+ (void)dismiss;

- (void)show;
- (void)showInView:(UIView *)superView;
- (void)showInView:(UIView *)superView wrapInteraction:(BOOL)wrapInteraction dim:(BOOL)dim;
- (void)dismiss;

@end
