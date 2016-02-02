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

@end
