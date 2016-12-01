//
//  JMGoodsDetailContainerViewController+NavigationBar.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController+NavigationBar.h"
#import "JMGoodsDetailLickButton.h"
#import "JMGoodsDetailShareButton.h"
#import "JMGoodsDetailPageController.h"
#import "JMGoodsDetail.h"


@implementation JMGoodsDetailContainerViewController (NavigationBar)

- (void)showNavigationBarIfNeeded {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    // 跳转社区的坑
    if (self.navigationController.navigationBar.translucent) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

#pragma mark - Title

- (void)setupNavigationTitle{
    if (self.navTitleView == nil) {
        JMGoodsDetailNavTitleView *titleView = [JMGoodsDetailNavTitleView instanceFromNib];
        titleView.title = @"图文详情";
        titleView.sectionTitles = @[@"商品", @"详情"];
        titleView.sectionTitleMaxCount = 3;
        titleView.frame = CGRectMake(0, 0, 180, 44);
        self.navTitleView = titleView;
        
        __weak __typeof(self) weakSelf = self;
        titleView.indexChangeBlock = ^(NSInteger index) {
            
            [weakSelf.pageViewController setSelectedControlerIndex:index notify:NO];
        };
        self.pageViewController.indexChangeBlock = ^(UIViewController *controller, NSUInteger index) {
            
            [weakSelf.navTitleView setSelectedSegmentIndex:index animated:YES notify:NO];
        };
    }
}

- (void)showNavigationTitleIfNeeded {
    
}

//显示商品，详情
- (void)updateNavigationTitleToGoodsAndGraphic {
    self.goodsDetailManager.goodsDetailContainer = self;
    self.goodsDetailManager.goodsDetailGoodsContainer = self.goodsDetailGoodsContainer;
    self.goodsDetailManager.graphicViewController = self.graphicViewController;
    
//    [self.goodsDetailManager synchronizeProduct:self.product];
    
    self.navTitleView.sectionTitles = @[@"商品", @"详情"];
    [self.pageViewController setViewControllers:@[self.goodsDetailGoodsContainer, self.graphicViewController]];
}

//显示商品，详情，口碑
- (void)updateNavigationTitleToGoodsAndGraphicAndPublicPraise {
    if (!self.publicPraiseViewController) {
        self.publicPraiseViewController = ({
            JMGoodsDetailPublicPraiseViewController *vc = [JMGoodsDetailPublicPraiseViewController instanceFromStoryboard];
            vc;
        });
    }
    
    self.goodsDetailManager.goodsDetailContainer = self;
    self.goodsDetailManager.goodsDetailGoodsContainer = self.goodsDetailGoodsContainer;
    self.goodsDetailManager.graphicViewController = self.graphicViewController;
    self.goodsDetailManager.publicPraiseViewController = self.publicPraiseViewController;
    
//    [self.goodsDetailManager synchronizeProduct:self.product];
    
    self.navTitleView.sectionTitles = @[@"商品", @"详情", @"口碑"];
    [self.pageViewController setViewControllers:@[self.goodsDetailGoodsContainer, self.graphicViewController, self.publicPraiseViewController]];
}

//显示商品，详情，评论
- (void)updateNavigationTitleToGoodsAndGraphicAndComment {
    if (!self.commentViewController) {
        self.commentViewController = ({
            JMGoodsDetailCommentViewController *vc = [JMGoodsDetailCommentViewController instanceFromStoryboard];
            vc;
        });
    }
    
    self.goodsDetailManager.goodsDetailContainer = self;
    self.goodsDetailManager.goodsDetailGoodsContainer = self.goodsDetailGoodsContainer;
    self.goodsDetailManager.graphicViewController = self.graphicViewController;
    self.goodsDetailManager.commentViewController = self.commentViewController;
    
//    [self.goodsDetailManager synchronizeProduct:self.product];
    
    self.navTitleView.sectionTitles = @[@"商品", @"详情", @"评价"];
    [self.pageViewController setViewControllers:@[self.goodsDetailGoodsContainer, self.graphicViewController, self.commentViewController]];
}

- (void)switchNavigationTitle {
    [self.navTitleView switchTitleAnimated];
}

- (void)changeToPage:(JMGoodsDetailPage)page {
    if (self.navTitleView.selectedSegmentIndex == page ||
        page < JMGoodsDetailPageGoods ||
        page > JMGoodsDetailPageComment) {
        return;
    }
    
    [self.navTitleView setSelectedSegmentIndex:page animated:YES notify:YES];
}

#pragma mark - RightItems

- (void)setupNavigationRightItems {
//    JMGoodsDtailRightBarButtonView *barButtonView = [JMGoodsDtailRightBarButtonView instanceWithViewController:self];
//    
//    __weak __typeof(self) weakSelf = self;
//    barButtonView.likeButton.didClickBlock = ^(JMGoodsDetailLickButton *lickButton) {
//        [weakSelf trackingWhenLikeButtonClicked];
//    };
//    barButtonView.shareButton.didClickBlock = ^(JMGoodsDetailShareButton *shareButton) {
//        [weakSelf trackingWhenShareButtonClicked];
//    };
//    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
//    if (kMainApplicationWidth <= 320.0f) {
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem arrayBarButtonItemWithUIBarButtonItem:rightButtonItem MoveRightWidth:10];
//    } else {
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem arrayBarButtonItemWithUIBarButtonItem:rightButtonItem];
//    }
//    
//    self.rightBarButtonView = barButtonView;
}

- (void)updateNavigationRightItems {
    
}

#pragma mark - LeftItems

- (void)setupNavigationLeftItems {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    customView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backsNextControllerEvent:(id)sender {
    if (self.navTitleView.selectedSegmentIndex != 0) {
        [self.navTitleView setSelectedSegmentIndex:0 animated:YES notify:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
