//
//  GestureTestView.m
//  ObjcSum
//
//  Created by sihuan on 16/3/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "GestureTestView.h"
#import "SimpleGestureRecognizers.h"
#import "UIView+YYMessage.h"

@interface GestureTestView ()<UIGestureRecognizerDelegate>

@end

@implementation GestureTestView

- (void)awakeFromNib {
    [self setContext];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setContext];
    }
    return self;
}

- (void)setContext {
    [self addSingleTapGesture];
    UIView *view = [SimpleGestureRecognizers newInstanceFromNib];
    [self addSubview:view];
    [view layoutEqualParent];
}


- (void)addSingleTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
//    tap.delaysTouchesBegan = YES;
//    tap.cancelsTouchesInView = NO;
//    tap.delaysTouchesEnded = NO;
    [self addGestureRecognizer:tap];
    
    
    
}

- (void)singleTap:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark 触摸事件处于"起步阶段"(starting phase)，当用户刚开始触摸屏幕时
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark 用户手指在屏幕上移动时
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark 用户手指从屏幕上拿开时
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark 触摸事件遭到系统阻断，比如电话来了
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    /**
     *  最好写全，这里可以用touchesEnded的逻辑
     */
//    [self touchesEnded:touches withEvent:event];
}

/**
 2016-03-30 17:17:29.854 ObjcSum[64381:1597492] -[GestureTestView gestureRecognizer:shouldReceiveTouch:]
 2016-03-30 17:17:29.855 ObjcSum[64381:1597492] -[GestureTestView gestureRecognizer:shouldRequireFailureOfGestureRecognizer:]
 2016-03-30 17:17:29.856 ObjcSum[64381:1597492] -[GestureTestView gestureRecognizer:shouldRequireFailureOfGestureRecognizer:]
 2016-03-30 17:17:29.858 ObjcSum[64381:1597492] -[GestureTestView gestureRecognizer:shouldRequireFailureOfGestureRecognizer:]
 2016-03-30 17:17:29.859 ObjcSum[64381:1597492] -[GestureTestView touchesBegan:withEvent:]
 2016-03-30 17:17:29.863 ObjcSum[64381:1597492] -[GestureTestView gestureRecognizerShouldBegin:]
 2016-03-30 17:17:29.863 ObjcSum[64381:1597492] -[GestureTestView singleTap:]
 2016-03-30 17:17:29.863 ObjcSum[64381:1597492] -[GestureTestView touchesCancelled:withEvent:]
 */
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}




@end






