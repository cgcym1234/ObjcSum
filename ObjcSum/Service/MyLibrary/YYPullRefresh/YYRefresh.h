//
//  YYRefresh.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"

/** 刷新控件的状态 */
typedef NS_ENUM(NSUInteger, YYRefreshState) {
    /** 普通闲置状态 */
    YYRefreshStateIdle,
    /** 松开就可以进行刷新的状态 */
    YYRefreshStateReady,
    /** 正在刷新中的状态 */
    YYRefreshStateRefreshing,
};

typedef NS_ENUM(NSUInteger, YYRefreshPosition) {
    YYRefreshPositionTop,
    YYRefreshPositionLeft,
    YYRefreshPositionBottom,
    YYRefreshPositionRight
};

@interface YYRefresh : UIView

@property (nonatomic, assign, readonly) YYRefreshPosition position;
@property (nonatomic, assign, readonly) YYRefreshState state;
@property (nonatomic, strong) YYRefreshConfig *config;

- (void)beginRefreshing;
- (void)endRefreshing;

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler;

- (instancetype)initWithScrollView:(UIScrollView *)scroll position:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config;

@end
