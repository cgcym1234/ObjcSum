//
//  YYRefreshConst.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, YYRefreshPosition) {
    YYRefreshPositionTop,
    YYRefreshPositionLeft,
    YYRefreshPositionBottom,
    YYRefreshPositionRight
};


/** 刷新控件的状态 */
typedef NS_ENUM(NSUInteger, YYRefreshState) {
    /** 普通闲置状态 */
    YYRefreshStateIdle,
    /** 松开就可以进行刷新的状态 */
    YYRefreshStateReady,
    /** 正在刷新中的状态 */
    YYRefreshStateRefreshing,
};

#define DegreesToRadians(degrees) ((degrees * M_PI) / 180.0)

// 文字颜色
#define YYRefreshLabelTextColor [UIColor colorWithWhite:0.400 alpha:1.000]
// 字体大小
#define YYRefreshLabelFont [UIFont boldSystemFontOfSize:14]

UIKIT_EXTERN const CGFloat YYRefreshViewHeight;
UIKIT_EXTERN const CGFloat YYRefreshReadyOffset;
UIKIT_EXTERN const CGFloat YYRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat YYRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const YYRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const YYRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const YYRefreshKeyPathContentSize;

UIKIT_EXTERN NSString *const YYRefreshIdleText;
UIKIT_EXTERN NSString *const YYRefreshReadyText;
UIKIT_EXTERN NSString *const YYRefreshRefreshingText;

UIKIT_EXTERN NSString *const YYRefreshImageUp;
UIKIT_EXTERN NSString *const YYRefreshImageDown;



