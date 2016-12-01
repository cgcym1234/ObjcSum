//
//  JMGoodsDetailContainerViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController.h"

#import "JMGoodsDetail.h"
#import "JMGoodsDetailContainerViewController+Network.h"
#import "JMGoodsDetailContainerViewController+ShoppingCat.h"
#import "JMGoodsDetailContainerViewController+NavigationBar.h"

@interface JMGoodsDetailContainerViewController ()


@end

@implementation JMGoodsDetailContainerViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailContainerViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateInitialViewController];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavigationBarIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {

}

#pragma mark - Override


#pragma mark - Initialization

- (void)setupContext {
    self.title = @"商品";
    
    [self setupUI];
    [self requestData];
}

- (void)setupUI {
    //pageViewController是在storyboard中添加的
    self.pageViewController = self.childViewControllers.firstObject;
    
    [self setupNavigationLeftItems];
    [self setupNavigationTitle];
    [self setupNavigationRightItems];
    
    //默认showOnly状态，请求到动态接口后重置
    self.showOnly = YES;
}

#pragma mark - Public

////请求到静态数据后的逻辑
//- (void)reloadWithStaticData:(MAProduct *)product {
//    
//}
//
////请求到静态和动态接口所有数据后的逻辑
//- (void)reloadWithWholeData:(MAProduct *)product staticDataLoaded:(BOOL)isStaticDataLoaded {
//    
//}

#pragma mark - Getter

- (JMGoodsDetailManager *)goodsDetailManager {
    if (!_goodsDetailManager) {
        _goodsDetailManager = [JMGoodsDetailManager new];
    }
    return _goodsDetailManager;
}

- (JMGoodsDetailGoodsContainerViewController *)goodsDetailGoodsContainer {
    if (!_goodsDetailGoodsContainer) {
        _goodsDetailGoodsContainer = ({
            JMGoodsDetailGoodsContainerViewController *vc = [JMGoodsDetailGoodsContainerViewController instanceFromStoryboard];
//            vc.isDisableAutoTrackPage = YES;
            vc;
        });
    }
    return _goodsDetailGoodsContainer;
}

- (JMGoodsDetailGraphicViewController *)graphicViewController {
    if (!_graphicViewController) {
        _graphicViewController = ({
            JMGoodsDetailGraphicViewController *vc = [JMGoodsDetailGraphicViewController instanceFromStoryboard];
//            vc.isDisableAutoTrackPage = YES;
            vc;
        });
    }
    return _graphicViewController;
}



@end




