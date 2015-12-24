//
//  YYDim.m
//  ObjcSum
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYDim.h"

#pragma mark - Consts

static NSTimeInterval const ShowDuration = 0.3;
static NSTimeInterval const DismissDuration = 0.2;

#define ColorDim [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]
#define ColorClear [UIColor clearColor]

@interface YYDim ()

@property (nonatomic, copy) void (^dismissCompletionBlock)(void);

@end

@implementation YYDim

#pragma mark - Life cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.animationType = YYDimAnimationFade;
        self.options = YYDimOpitionDark | YYDimOpitionDismissAuto;
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)layoutSubviews {
    self.frame = [UIScreen mainScreen].bounds;
    self.showView.center = self.center;
}

#pragma mark - Override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_options & YYDimOpitionDismissAuto) {
        [self dismssAnimated:YES completion:_dismissCompletionBlock];
    }
}

#pragma mark - Private

- (void)show:(BOOL)show {
    if (self.showView) {
        self.showView.transform = show ? CGAffineTransformIdentity : CGAffineTransformScale(_showView.transform, 0.8, 0.8);
        self.showView.alpha = show ? 1 : 0;
    }
    
    self.alpha = show ? 1 : 0;
}

- (void)removeShowView {
    if (_showView) {
        [_showView removeFromSuperview];
        _showView = nil;
    }
}

#pragma mark - Public

- (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(YYDimOpition)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    
    self.options = options;
    self.backgroundColor = options & YYDimOpitionDark ? ColorDim : ColorClear;
    
    [self removeShowView];
    [self removeFromSuperview];
    
    if (view) {
        [self addSubview:view];
    }
    self.showView = view;
    
    #pragma mark  找到当前显示的window
    NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == [UIScreen mainScreen];
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    
    if (animationType) {
        [self show:NO];
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self show:YES];
                             if (animations) {
                                 animations();
                             }
                         }
                         completion:completion];
    } else {
        [self show:YES];
    }
    
    return self;
}

- (void)dismssAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        [UIView animateWithDuration:DismissDuration delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
            [self show:NO];
        } completion:^(BOOL finished) {
            [self show:YES];
            [self removeShowView];
            [self removeFromSuperview];
            if (completion) {
                completion();
            }
            _dismissCompletionBlock = nil;
        }];
    } else {
        [self removeShowView];
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
        _dismissCompletionBlock = nil;
    }
}

+ (instancetype)showView:(UIView *)view {
    return [self showView:view animation:YYDimAnimationFade options:YYDimOpitionDark|YYDimOpitionDismissAuto];
}

+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType {
    return [self showView:view animation:animationType options:YYDimOpitionDark|YYDimOpitionDismissAuto];
}

+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType options:(YYDimOpition)options {
    return [[self sharedInstance] showView:view animation:animationType duration:ShowDuration delay:0 options:options animations:nil completion:nil];
}

+ (instancetype)showView:(UIView *)view animation:(YYDimAnimation)animationType duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(YYDimOpition)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    return [[self sharedInstance] showView:view animation:animationType duration:duration delay:delay options:options animations:animations completion:completion];
}

+ (void)dismss {
    return [self dismssAnimated:YES];
}

+ (void)dismssCompletion:(void (^)(void))completion {
    return [[self sharedInstance] dismssAnimated:YES completion:completion];
}

+ (void)dismssAnimated:(BOOL)animated {
    return [[self sharedInstance] dismssAnimated:animated completion:nil];
}

+ (void)dismssAnimated:(BOOL)animated completion:(void (^)(void))completion {
    YYDim *dim = [self sharedInstance];
    dim.dismissCompletionBlock = [completion copy];
    return [dim dismssAnimated:animated completion:completion];
}

@end
