//
//  DragImageViewGesture3.m
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "DragImageViewGesture3.h"
#import "UIView+Transform.h"

@interface DragImageViewGesture3 ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat tx;
@property (nonatomic, assign) CGFloat ty;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat rotationAngle;

@end

@implementation DragImageViewGesture3

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
    
    _tx = 0.0f; _ty = 0.0f; _scale = 1.0f;	_rotationAngle = 0.0f;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.gestureRecognizers = @[pan, rotation, pinch];
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        recognizer.delegate = self;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // initialize translation offsets
    _tx = self.transform.tx;
    _ty = self.transform.ty;
    _scale = self.scale;
    _rotationAngle = self.rotation;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    /**
     *  这里相当于加了一个3连击的手势判断，还原View transform
     所以使用touchesBegan等回调和添加UIGestureRecognizer手势的方法是可以的共用
     */
    if (touch.tapCount == 3) {
        /**
         *  UITouch对象保存了含有手势识别器的数组。
         如果没有手势的话，数组就是空的
         */
        self.transform = CGAffineTransformIdentity;
        _tx = 0.0f; _ty = 0.0f; _scale = 1.0f;	_rotationAngle = 0.0f;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)updateTransformWithOffset:(CGPoint)translation {
    self.transform = CGAffineTransformMakeTranslation(_tx + translation.x, _ty + translation.y);
    self.transform = CGAffineTransformRotate(self.transform, _rotationAngle);
    
    if (_scale > 0.5) {
        self.transform = CGAffineTransformScale(self.transform, _scale, _scale);
    } else {
        self.transform = CGAffineTransformScale(self.transform, 0.5f, 0.5f);
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.superview];
    [self updateTransformWithOffset:translation];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer
{
    _rotationAngle = gestureRecognizer.rotation;
    [self updateTransformWithOffset:CGPointZero];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    _scale = gestureRecognizer.scale;
    [self updateTransformWithOffset:CGPointZero];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    /**
     *  返回YES，让多个手势可以同时生效，
     否则同一时刻只有一个手势起作用
     */
    return YES;
}


#pragma mark - 解决手势冲突

#pragma mark 1 requireGestureRecognizerToFail

- (void)gestureConflict {
    UITapGestureRecognizer *ges1;
    UITapGestureRecognizer *ges2;
    
    /**
     *  当ges1无法触发，ges2才生效
     */
    [ges2 requireGestureRecognizerToFail:ges1];
    
}

#pragma mark 2 代理

/**
 *  下面2个返回YES，意味着必须等到某个手势彻底无法触发才能响应另一个手势。
 
 如果设定了手势间的依赖，意味着识别器的反应时间会有所延迟，
 因为它要等到另一个识别器彻底失败为止。
 
 比如，要同时识别单击和双击，那么再第一次点击后，需要多等一会儿才能确定
 是否发生了单机。
 
 为了适应这种规则变化，GUI的响应能力会下降，单击操作会稍微"迟钝"。
 
 如果有非常高的要求，不要同时设置2种手势，可以动态添加删除。
 */
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}



@end


































