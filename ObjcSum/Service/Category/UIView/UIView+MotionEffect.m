//
//  UIView+MotionEffect.m
//  NewSkills
//
//  Created by sihuan on 15/1/21.
//  Copyright (c) 2015年 huansi. All rights reserved.
//

#import "UIView+MotionEffect.h"
#import <objc/runtime.h>


static char motionEffectFlag;

@implementation UIView (MotionEffect)

- (void)setEffectGroup:(UIMotionEffectGroup *)effectGroup
{
    // 清除掉关联
    //objc_setAssociatedObject(self, &motionEffectFlag, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 建立关联
    objc_setAssociatedObject(self, &motionEffectFlag, effectGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIMotionEffectGroup *)effectGroup
{
    // 返回关联
    return objc_getAssociatedObject(self, &motionEffectFlag);
}

#pragma mark - 添加运动视差效果
- (void)addMotionEffectHorizontal:(CGFloat)xValue vertical:(CGFloat)yValue;
{
    static NSString * centerXKey = @"center.x";
    static NSString * centerYKey = @"center.y";
    
    NSMutableArray *motionEffects = [NSMutableArray arrayWithCapacity:2];
    
    if (xValue > 0) {
        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:centerXKey type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = @(-xValue);
        xAxis.maximumRelativeValue = @(xValue);
        
        [motionEffects addObject:xAxis];
    }
    
    if (yValue > 0) {
        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:centerYKey type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = @(-yValue);
        yAxis.maximumRelativeValue = @(yValue);
        [motionEffects addObject:yAxis];
    }
    
    // 先移除效果再添加效果
    [self removeMotionEffect:self.effectGroup];
    
    UIMotionEffectGroup *motionGroup = [[UIMotionEffectGroup alloc] init];
    motionGroup.motionEffects = motionEffects;
    self.effectGroup = motionGroup;
    
    // 给view添加效果
    [self addMotionEffect:self.effectGroup];
}

- (void)removeSelfMotionEffect
{
    [self removeMotionEffect:self.effectGroup];
}


@end
