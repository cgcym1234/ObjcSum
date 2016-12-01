//
//  JMGoodsDetailManager.m
//  JuMei
//
//  Created by yangyuan on 2016/9/20.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"
#import "JMGoodsDetail.h"
#import "JMGoodsDetailContainerViewController+ShoppingCat.h"
#import "JMGoodsDetailContainerViewController+Network.h"
#import "JMGoodsDetailContainerViewController+NavigationBar.h"
#import "JMGoodsDetailGoodsViewController.h"

@implementation JMGoodsDetailManager

#pragma mark - UI

//titleView和图文详情的切换
- (void)switchNavigationTitle {
    [_goodsDetailContainer switchNavigationTitle];
}

- (void)changeToPage:(JMGoodsDetailPage)page {
    [_goodsDetailContainer changeToPage:page];
}

- (void)setHorizontalScrollEnable:(BOOL)enable {
    [_goodsDetailContainer.pageViewController setScrollEnabled:enable];
}

- (void)showDetailSKUView {
//    [_goodsDetailGoodsContainer.goodsViewController showDetailSKUView];
}

#pragma mark - Reload Data

//更新整个商品详情所有界面，商品，详情，口碑，评论
- (void)reloadGoodsDetailAll {
    [_goodsDetailContainer showBrowseHistoryButtonIfNeeded];
    
    [self reloadGoodsPageAll];
    
    [_graphicViewController reloadData];
    [_publicPraiseViewController reloadData];
    [_commentViewController reloadData];
}

//更新商品页 header tablview shoppingCat
- (void)reloadGoodsPageAll {
    [_goodsDetailGoodsContainer.goodsViewController reloadAll];
    [self reloadShoppingCat];
}

//更新商品页 header tablview
- (void)reloadGoodsPageListAndHeader {
    [self reloadGoodsPageHeader];
    [self reloadGoodsPageList];
}

//更新商品页 header
- (void)reloadGoodsPageHeader {
    [_goodsDetailGoodsContainer.goodsViewController reloadHeader];
}

//更新商品页tablview
- (void)reloadGoodsPageList {
    [_goodsDetailGoodsContainer.goodsViewController reloadList];
}

//更新购物车
- (void)reloadShoppingCat {
//    [_goodsDetailContainer reloadShoppingCatView];
}


#pragma mark - Setter

- (void)setGoodsDetailGoodsContainer:(JMGoodsDetailGoodsContainerViewController *)goodsDetailGoodsContainer {
    _goodsDetailGoodsContainer = goodsDetailGoodsContainer;
    _goodsDetailGoodsContainer.goodsDetailManager = self;
    goodsDetailGoodsContainer.goodsViewController.goodsDetailManager = self;
    
    //保证使用同一个graphicViewController
    goodsDetailGoodsContainer.graphicViewController = self.graphicViewController;
}

- (void)setGraphicViewController:(JMGoodsDetailGraphicViewController *)graphicViewController {
    _graphicViewController = graphicViewController;
    
    //保证使用同一个graphicViewController
    _goodsDetailGoodsContainer.graphicViewController = graphicViewController;
}

//- (void)setProduct:(MAProduct *)product {
//    _product = product;
//    _goodsDetailContainer.product = product;
//    _goodsDetailGoodsContainer.product = product;
//    _graphicViewController.product = product;
//    _publicPraiseViewController.product = product;
//    _commentViewController.product = product;
//    
//    _goodsDetailGoodsContainer.goodsViewController.product = product;
//    _goodsDetailGoodsContainer.graphicViewController.product = product;
//}

#pragma mark - Getter

- (NSString *)currentSku {
    return _goodsDetailGoodsContainer.goodsViewController.currentSku;
}

- (UIImage *)defaultGoodsImage {
    return [_goodsDetailGoodsContainer.goodsViewController defaultGoodsImage];
}

- (UIImage *)currentGoodsImage {
    return [_goodsDetailGoodsContainer.goodsViewController currentGoodsImage];
}

@end
