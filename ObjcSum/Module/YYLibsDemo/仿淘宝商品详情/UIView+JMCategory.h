//
//  UIView+JMCategory.h
//  JuMei
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JMCategory)

//animated yes, duration 3.0
- (void)showTip:(NSString *)tip;
- (void)showTip:(NSString *)tip animated:(BOOL)animated;
- (void)showTip:(NSString *)tip animated:(BOOL)animated duration:(CGFloat)duration;



+ (UINib *)jm_nib;
+ (NSString *)jm_identifier;

#pragma mark - Border
- (CALayer *)addBorderTopPadding:(CGFloat)padding height:(CGFloat)height color:(UIColor *)color;
- (CALayer *)addBorderBottomPadding:(CGFloat)padding height:(CGFloat)height color:(UIColor *)color;
- (CALayer *)addBorderAtX:(CGFloat)x
                   y:(CGFloat)y
               width:(CGFloat)width
              height:(CGFloat)height
               color:(UIColor *)color;


@end















