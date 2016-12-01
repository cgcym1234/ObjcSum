//
//  JMGoodsDetailContainerViewController+ShoppingCat.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController.h"


@interface JMGoodsDetailContainerViewController ()

// 底部购物车View
@property (nonatomic, weak) IBOutlet UIView *bottomContainerView;
//@property (nonatomic, strong) MAEDetailBottomBarView *shoppingCatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerViewHeight;

@property (nonatomic, strong) UIView *addToCartAnimationImageView;
@end

@interface JMGoodsDetailContainerViewController (ShoppingCat)

- (void)setupShoppingCatView;

- (void)setShoppingCatHidden:(BOOL)hidden;

@end
