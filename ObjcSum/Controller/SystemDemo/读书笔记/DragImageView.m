//
//  DragImageView.m
//  ObjcSum
//
//  Created by sihuan on 16/1/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "DragImageView.h"

@interface DragImageView ()

@property (nonatomic, assign) CGPoint startLocation;
@end

@implementation DragImageView

#pragma mark - Initialize

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setContext];
    }
    return self;
}

- (void)setContext {
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"ChatWindow_DefaultAvatar"];
}

#pragma mark 触摸事件处于"起步阶段"(starting phase)，当用户刚开始触摸屏幕时
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //保存点击坐标
    _startLocation = [[touches anyObject] locationInView:self];
    [self.superview bringSubviewToFront:self];
}

#pragma mark 用户手指在屏幕上移动时
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - _startLocation.x;
    float dy = pt.y - _startLocation.y;
    CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    self.center = newCenter;
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

@end
