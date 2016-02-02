//
//  DragImageViewGesture.m
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "DragImageViewGesture.h"


@interface DragImageViewGesture ()

@property (nonatomic, assign) CGPoint previousLocation;
@end

@implementation DragImageViewGesture

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
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //保存点击坐标
    _previousLocation = self.center;
    [self.superview bringSubviewToFront:self];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint newCenter = CGPointMake(self.center.x + self.transform.tx, self.center.y + self.transform.ty);
        
        //最后改变view实际位置
        self.center = newCenter;
        self.transform = CGAffineTransformIdentity;
        return;
    }
    
    /**
     *  仿射变换与简单的偏移量不同，可以同时达成旋转，缩放，平移操作。
     为了支持变换，手势识别器以绝对量的方式来描述坐标改变，而不是给出2次改变的相对差值。
     这样就不需要把多个偏移量累加起来。
     
     UIPanGestureRecognizer只返回一个变化量，且以某个view的坐标系来描述位置的变化。
     一般使用superView
     */
    CGPoint translation = [pan translationInView:self.superview];
    CGAffineTransform transform = self.transform;
    transform.tx = translation.x;
    transform.ty = translation.y;
    self.transform = transform;
    
    /**
     *  如果使用这种方式需要记录_previousLocation
     */
//    self.center = CGPointMake(_previousLocation.x + translation.x, _previousLocation.y + translation.y);
}
@end























