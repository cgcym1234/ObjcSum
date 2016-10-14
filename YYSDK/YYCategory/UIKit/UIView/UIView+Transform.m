//
//  UIView+Transform.m
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIView+Transform.h"

@implementation UIView (Transform)

- (CGFloat)scaleX
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat)scaleY
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat)rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

/**
 如果直接设置anchorPoint，frame会改变
 参考：http://blog.csdn.net/yongyinmg/article/details/37927833
 */
- (void)setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

@end
