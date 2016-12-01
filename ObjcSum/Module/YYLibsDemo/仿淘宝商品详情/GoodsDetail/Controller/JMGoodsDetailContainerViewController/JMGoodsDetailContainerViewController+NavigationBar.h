//
//  JMGoodsDetailContainerViewController+NavigationBar.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController.h"
#import "JMGoodsDetailNavTitleView.h"
#import "JMGoodsDetailPageController.h"
#import "JMGoodsDetailCommentViewController.h"
#import "JMGoodsDetailPublicPraiseViewController.h"
#import "JMGoodsDetailGoodsContainerViewController.h"
#import "JMGoodsDetailGraphicViewController.h"
#import "JMGoodsDtailRightBarButtonView.h"

@interface JMGoodsDetailContainerViewController ()

@property (nonatomic, strong) JMGoodsDetailNavTitleView *navTitleView;
@property (nonatomic, strong) JMGoodsDtailRightBarButtonView *rightBarButtonView;

@property (nonatomic, weak) IBOutlet JMGoodsDetailPageController *pageViewController;

@property (nonatomic, strong) JMGoodsDetailGoodsContainerViewController *goodsDetailGoodsContainer;
@property (nonatomic, strong) JMGoodsDetailGraphicViewController *graphicViewController;
@property (nonatomic, strong) JMGoodsDetailPublicPraiseViewController *publicPraiseViewController;
@property (nonatomic, strong) JMGoodsDetailCommentViewController *commentViewController;

//隐藏购物车，喜欢，分享，加价购需求
@property (nonatomic, assign) BOOL showOnly;

@end

@interface JMGoodsDetailContainerViewController (NavigationBar)

- (void)showNavigationBarIfNeeded;

//会拦截返回事件
- (void)setupNavigationLeftItems;

- (void)setupNavigationTitle;
- (void)showNavigationTitleIfNeeded;

//titleView的segment和图文详情切换
- (void)switchNavigationTitle;

//显示喜欢，分享
- (void)setupNavigationRightItems;
- (void)updateNavigationRightItems;

//商品，详情，口碑等页面跳转
- (void)changeToPage:(JMGoodsDetailPage)page;

//显示商品，详情
- (void)updateNavigationTitleToGoodsAndGraphic;

//显示商品，详情，口碑
- (void)updateNavigationTitleToGoodsAndGraphicAndPublicPraise;

//显示商品，详情，评论
- (void)updateNavigationTitleToGoodsAndGraphicAndComment;

@end
