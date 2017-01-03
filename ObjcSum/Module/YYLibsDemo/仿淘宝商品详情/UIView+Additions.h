//
//  UIView+Additions.h
//  MallLVC
//
//  Created by jianning on 14-6-5.
//  Copyright (c) 2014年 jumei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIViewRoundedCornerNone = 0,
    UIViewRoundedCornerUpperLeft = 1 << 0,
    UIViewRoundedCornerUpperRight = 1 << 1,
    UIViewRoundedCornerLowerLeft = 1 << 2,
    UIViewRoundedCornerLowerRight = 1 << 3,
    UIViewRoundedCornerAll = (1 << 4) - 1,
} CellBackgroundViewPosition;

typedef NSInteger UIViewRoundedCornerMask;  //这个是UITableView选中

@interface UIView (Additions)
/**
 *  @brief 获取window的最上层view
 *
 *  @return window的最上层view
 */
+ (UIView *)topView;
/**
 *  @brief 获取当前view在父View的坐标
 *
 *  @return 坐标
 */
- (CGPoint)originInTopView;
/**
 *  @brief 获取View所在VC
 *
 *  @return View所在VC
 */
- (UIViewController*)viewController;
/**
 *  @brief 获取Frame的中心
 *
 *  @return center
 */
- (CGPoint)centerOfFrame;
/**
 *  @brief 获取Bounds的中心
 *
 *  @return center
 */
- (CGPoint)centerOfBounds;
/**
 *  @brief 通过tag取子View
 *
 *  @param tag tag
 *
 *  @return 子View
 */
- (UIView*)subViewWithTag:(int)tag;
/**
 *  @brief 得到当前的keyView
 *
 *  @return keyView
 */
+ (UIView *)keyView;

/**
 *  @brief 设置UIView圆角
 *
 *  @param corners 圆角类型
 *  @param radius  圆角值
 */
- (void)setRoundedCorners:(UIViewRoundedCornerMask)corners radius:(CGFloat)radius;

/**
 *  @brief 截屏
 */
- (UIImage *)snapshotWithBound:(CGRect)bounds;

/**
 *  @brief 移除所有subview
 */
- (void)removeSubviews ;

@end
