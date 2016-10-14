//
//  UIView+MotionEffect.h
//  NewSkills
//
//  Created by sihuan on 15/1/21.
//  Copyright (c) 2015年 huansi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MotionEffect)

@property (nonatomic, strong) UIMotionEffectGroup *effectGroup;

#pragma mark - 添加运动视差效果
- (void)addMotionEffectHorizontal:(CGFloat)xValue vertical:(CGFloat)yValue;
- (void)removeSelfMotionEffect;

@end
