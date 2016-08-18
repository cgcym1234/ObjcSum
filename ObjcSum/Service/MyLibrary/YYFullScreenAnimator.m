//
//  YYFullScreenAnimator.m
//  MLLCustomer
//
//  Created by sihuan on 2016/7/25.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "YYFullScreenAnimator.h"
#import "UIImage+Extension.h"

@interface YYFullScreenAnimator()

@property (nonatomic, assign) CGRect initialFrame;

@end

@implementation YYFullScreenAnimator

- (instancetype)initWithInitialImageView:(UIImageView *)imageView initialFrame:(CGRect)initialFrame {
    self = [super init];
    if (self) {
        _animatingImageView = [UIImageView new];
        _animatingImageView.image = imageView.image;
        _animatingImageView.contentMode = imageView.contentMode;
        //避免图片超过fame的动画问题
        _animatingImageView.clipsToBounds = YES;
        _initialFrame = initialFrame;
    }
    return self;
}

- (instancetype)initWithInitialImageView:(UIImageView *)imageView {
    CGRect frame = [imageView.superview convertRect:imageView.frame toView:[[UIApplication sharedApplication].delegate window]];
    return [self initWithInitialImageView:imageView initialFrame:frame];
}

- (CGRect)finalFrameWithImage:(UIImageView *)imageView inView:(UIView *)toView {
    if (!imageView.image) {
        imageView.center = toView.center;
        return imageView.frame;
    }
    
    CGSize fitSize = [imageView.image fitSizeInView:toView];
    
    imageView.frame = CGRectMake(0,
                                 0,
                                 fitSize.width,
                                 fitSize.height);
    imageView.center = toView.center;
    
    return imageView.frame;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? 0.3 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *toView = toVc.view;
    
    [containerView addSubview:toView];
    [containerView addSubview:_animatingImageView];
    
    BOOL isPresenting = toVc.presentingViewController == fromVc;
    
    CGRect imageFinalFrame = [self finalFrameWithImage:_animatingImageView inView:toView];
    
    if (isPresenting) {
        _animatingImageView.frame = _initialFrame;
    } else {
        _animatingImageView.frame = imageFinalFrame;
        toView.alpha = 0.1;
    }
    
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVc];
    toView.frame = toViewFinalFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        _animatingImageView.frame = isPresenting ? imageFinalFrame : _initialFrame;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [_animatingImageView removeFromSuperview];
    }];
}

- (void)setAnimatingImage:(UIImage *)image {
    _animatingImageView.image = image;
}

@end
