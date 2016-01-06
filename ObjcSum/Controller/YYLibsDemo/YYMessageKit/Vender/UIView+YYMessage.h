//
//  UIView+YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YYMessage)

#pragma mark - 圆形设置

@property (nonatomic, assign) BOOL round;

#pragma mark - view坐标和大小相关

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (id)subviewWithTag:(NSInteger)tag;

- (UIViewController*)viewController;

@end
