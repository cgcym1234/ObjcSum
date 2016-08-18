//
//  YYFullScreenAnimator.h
//  MLLCustomer
//
//  Created by sihuan on 2016/7/25.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYFullScreenAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIImageView *animatingImageView;

- (instancetype)initWithInitialImageView:(UIImageView *)imageView;
- (instancetype)initWithInitialImageView:(UIImageView *)imageView initialFrame:(CGRect)initialFrame;

- (void)setAnimatingImage:(UIImage *)image;

@end
