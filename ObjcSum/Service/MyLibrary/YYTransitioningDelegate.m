//
//  YYTransitioningDelegate.m
//  MLLCustomer
//
//  Created by yangyuan on 16/7/21.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "YYTransitioningDelegate.h"
#import "YYFullScreenAnimator.h"
#import "UIImage+Extension.h"

@interface YYTransitioningDelegate ()

@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) CGRect finalFrame;

@end

@implementation YYTransitioningDelegate


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[YYFullScreenAnimator alloc] initWithInitialImageView:_animatingImageView initialFrame:_initialFrame];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _dismissAnimated ? [[YYFullScreenAnimator alloc] initWithInitialImageView:_animatingImageView initialFrame:_initialFrame] : nil;
}

- (void)setInitialImageView:(UIImageView *)imageView {
    _initialImageView = imageView;
    _initialFrame = [imageView.superview convertRect:imageView.frame toView:[[UIApplication sharedApplication].delegate window]];
    self.animatingImageView = imageView;
}

- (void)setAnimatingImageView:(UIImageView *)imageView {
    _animatingImageView = imageView;
}


@end
