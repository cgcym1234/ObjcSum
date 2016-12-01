//
//  JMGoodsDetailContainerViewController+ShoppingCat.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController+ShoppingCat.h"
#import "JMGoodsDetailContainerViewController+Network.h"
#import "JMGoodsDetail.h"
#import "Masonry.h"

@implementation JMGoodsDetailContainerViewController (ShoppingCat)

- (void)setupShoppingCatView {
    
//    [self.bottomContainerView addSubview:self.shoppingCatView];
//    [self.shoppingCatView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.bottomContainerView);
//    }];
}

- (void)setShoppingCatHidden:(BOOL)hidden {
    self.bottomContainerViewHeight.constant = hidden ? 0 : 49;
    self.bottomContainerView.hidden = hidden;
}


#pragma mark - Geter Setter


@end





