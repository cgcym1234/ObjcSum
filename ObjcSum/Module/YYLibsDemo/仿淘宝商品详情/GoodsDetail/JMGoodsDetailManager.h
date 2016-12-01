//
//  JMGoodsDetailManager.h
//  JuMei
//
//  Created by yangyuan on 2016/9/20.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMGoodsDetail.h"

@class JMGoodsDetailContainerViewController, JMGoodsDetailGoodsViewController, JMGoodsDetailPageController, JMGoodsDetailGoodsContainerViewController, JMGoodsDetailGraphicViewController, JMGoodsDetailPublicPraiseViewController, JMGoodsDetailCommentViewController, JMAdvertData, JMPublicPraise, MAProductCommentInfo, MAEDetailPriceTableViewCell;

/** 协调所有controller相关逻辑*/
@interface JMGoodsDetailManager : NSObject

@property (nonatomic, weak) JMGoodsDetailContainerViewController *goodsDetailContainer;
@property (nonatomic, weak) JMGoodsDetailGoodsContainerViewController *goodsDetailGoodsContainer;
@property (nonatomic, weak) JMGoodsDetailGraphicViewController *graphicViewController;
@property (nonatomic, weak) JMGoodsDetailPublicPraiseViewController *publicPraiseViewController;
@property (nonatomic, weak) JMGoodsDetailCommentViewController *commentViewController;

//@property (nonatomic, weak) MAProduct *product;
@property (nonatomic, readonly) NSString                                   *currentSku;

//默认的图片，用于加入购物车等动画
@property (nonatomic, weak, readonly) UIImage                                *defaultGoodsImage;
//当前选中的image，用于分享等
@property (nonatomic, weak, readonly) UIImage                                *currentGoodsImage;



#pragma mark - UI

//titleView的segment和图文详情切换
- (void)switchNavigationTitle;

//商品，详情，口碑等页面跳转
- (void)changeToPage:(JMGoodsDetailPage)page;

- (void)setHorizontalScrollEnable:(BOOL)enable;

- (void)showDetailSKUView;

#pragma mark - Reload Data

//更新整个商品详情所有界面，商品，详情，口碑，评论
- (void)reloadGoodsDetailAll;

//更新商品页 header tablview shoppingCat
- (void)reloadGoodsPageAll;

//更新商品页 header 图片
- (void)reloadGoodsPageHeader;

//更新商品页tablview的所有cell
- (void)reloadGoodsPageList;

//更新购物车
- (void)reloadShoppingCat;

//更新商品页tablview 添加口碑或评论
- (void)reloadGoodsPageListWithPublicPraiseData:(JMPublicPraise *)publicPraise;
- (void)reloadGoodsPageListWithCommentData:(MAProductCommentInfo *)commentData;

//更新商品页广告
- (void)reloadGoodsPageHeaderWithAdvertisementData:(NSArray<JMAdvertData *> *)advertisements;

#pragma mark - Business

//同步所有controller的product
//- (void)synchronizeProduct:(MAProduct *)product;

- (void)requestDynamicDataWhenCountdownEndIfNeeded;

- (void)addGoodsToShoppingCat;

//预售，加入心愿单
- (void)addWishGoodsToShoppingCat;

- (void)autoPlayVedioIfNeeded;

@end
