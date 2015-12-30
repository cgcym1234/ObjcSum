//
//  YYDim.h
//  ObjcSum
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYDimAnimation) {
    // 无动画
    YYDimAnimationNone = 0,
    YYDimAnimationFade,
    YYDimAnimationZoom,
};

typedef NS_OPTIONS(NSUInteger, YYDimOpition) {
    /// 透明背景，不会点击消失
    YYDimOpitionNone = 0,
    /// 蒙版效果，黑色透明背景
    YYDimOpitionDark = 1 << 0,
    /// 点击蒙版自动消失
    YYDimOpitionDismissAuto = 1 << 1,
};

@interface YYDim : UIView

/**
 *  默认YYDimAnimationFade
 */
@property (nonatomic, assign) YYDimAnimation animationType;

/**
 *  默认是蒙版效果，点击消失
 */
@property (nonatomic, assign) YYDimOpition options;
@property (nonatomic, strong) UIView *showView;

/**
 *  居中显示viw
 *
 *  @param view     view
 *  @param animated 是否动画显示
 *
 *  @return YYDim
 */
+ (instancetype)showView:(UIView *)view;
+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType;
+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType options:(YYDimOpition)options;
+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animated duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(YYDimOpition)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)dismss;
+ (void)dismssCompletion:(void (^)(void))completion;

@end
