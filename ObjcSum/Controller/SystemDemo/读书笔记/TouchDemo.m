//
//  TouchDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/1/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "TouchDemo.h"

@implementation TouchDemo

#pragma mark - 触摸生命周期

/**
 *  每个触摸操作都处于下列5个阶段之一
 
 phase 英 feɪz  美 fez 相位，阶段
 stationary 英 'steɪʃ(ə)n(ə)rɪ  美 'steʃənɛri 静止，固定的
 
 typedef NS_ENUM(NSInteger, UITouchPhase) {
 UITouchPhaseBegan,             // 手指触摸到屏幕时
 UITouchPhaseMoved,             // 手指在屏幕上移动时
 UITouchPhaseStationary,        // 上一个事件结束后，手指仍然在屏幕上，但没有移动
 UITouchPhaseEnded,             // 手指从屏幕上离开
 UITouchPhaseCancelled,         // 触摸没有结束，但是系统又不再追踪该操作，通常是因为系统中断导致 (程序不在处于活动状态或者相关view被移走了，比如电话来了)
 };

 */

#pragma mark - 1.1.2 UIResponder类中的触摸事件响应方法

#pragma mark 触摸事件处于"起步阶段"(starting phase)，当用户刚开始触摸屏幕时
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

#pragma mark 用户手指在屏幕上移动时
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark 用户手指从屏幕上拿开时
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark 触摸事件遭到系统阻断，比如电话来了
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /**
     *  最好写全，这里可以用touchesEnded的逻辑
     */
    [self touchesEnded:touches withEvent:event];
}

#pragma mark 注意exlusive touch
/**
 *  此模式会阻止系统把触摸事件投递给同一个视窗里面的其他View。
 启用后，即self.exclusiveTouch = YES;
 这个视图里的其他视图就收不到触摸事件了，而是由主View来专门负责处理全部触摸事件。
 
 */

@end


























