//
//  HitTestViewApplication.m
//  ObjcSum
//
//  Created by sihuan on 16/3/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "HitTestViewApplication.h"

@implementation HitTestViewApplication

#pragma mark - 1. 扩大按钮的点击区域
/**
 *  扩大按钮的点击区域(按钮四周之外的10pt也可以响应按钮的事件)
 *  在方法里面判断如果point在button的frame之外的10pt内，就返回button自己。
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.0) {
        return nil;
    }
    CGRect touchRect = CGRectInset(self.bounds, -10, -10);
    if (CGRectContainsPoint(touchRect, point)) {
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            //把自己控件上的点转换成子控件上的点
            CGPoint convertedPoiont = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertedPoiont withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}

#pragma mark - 2. 将事件传递给兄弟view

/**
 *  如果需要是需要view A响应事件而不是B(即使点在重叠的部分)，
 什么都不做的话，当点击在重叠的时候，A是不能响应事件的，除非B的userInteractionEnabled为NO并且者B没有任何事件的响应函数。
 这个时候通过重写B的hittest可以解决这个问题，在B的hittest里面直接返回nil就行了。
 */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitTestView = [super hitTest:point withEvent:event];
//    if (hitTestView == self) {
//        return nil;
//    }
//    return hitTestView;
//}

#pragma mark - 3. 将事件传递给subview

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitTestView = [super hitTest:point withEvent:event];
//    if (hitTestView) {
//        hitTestView = self.scrollView;
//    }
//    return hitTestView;
//}

@end
