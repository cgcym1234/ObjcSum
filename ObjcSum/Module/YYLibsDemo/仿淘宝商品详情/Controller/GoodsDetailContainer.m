//
//  GoodsDetailContainer.m
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetailContainer.h"
#import "JMSkuSelectedViewModel+JMSku.h"

#import "GoodsDetail.h"
#import "GoodsDetailNomalViewController.h"
#import "GoodsDetailGraphicViewController.h"
#import "UIViewController+Extension.h"
#import "JMSkuSelectedView.h"

@interface GoodsDetailContainer ()
<GoodsDetailEventDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) GoodsDetailNomalViewController *goodsController;
@property (nonatomic, strong) GoodsDetailGraphicViewController *goodsGrapicController;
@property (nonatomic, assign) GoodsDetailType type;

@property (nonatomic, strong) JMSkuSelectedViewModel *selectedViewModel;

@end

@implementation GoodsDetailContainer

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setContext {
    [self setupUI];
    
    JMSkuModel *skuModel = [JMSkuSelectedViewModel requestData];
    _selectedViewModel = [JMSkuSelectedViewModel instanceWithSkuModel:skuModel];
}

- (void)setupUI {
    self.title = @"商品详情";
    [self showGoodsController];
    [self addRightBarButtonItemWithTitle:@"showSku" action:@selector(showSku)];
}

- (void)showSku {
    
    [[JMSkuSelectedView new] showInWindowWithData:_selectedViewModel];
}

- (void)showGoodsController {
    if (!_goodsController) {
        [self addChildViewController:self.goodsController];
        [self.view addSubview:_goodsController.view];
    }
    
    if (_goodsGrapicController) {
        CGRect originFrame = self.view.bounds;
        CGRect goodsControllerFrame = originFrame;
        CGRect goodsGrapicControllerFrame = originFrame;
        
        goodsControllerFrame.origin.y -= CGRectGetHeight(originFrame);
        _goodsController.view.frame = goodsControllerFrame;
        
        goodsGrapicControllerFrame.origin.y += CGRectGetHeight(originFrame);
        _goodsGrapicController.view.frame = originFrame;
        
        [self transitionFromViewController:_goodsGrapicController toViewController:_goodsController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            _goodsController.view.frame = originFrame;
            _goodsGrapicController.view.frame = goodsGrapicControllerFrame;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)showGoodsGrapicController {
    if (!_goodsGrapicController) {
        [self addChildViewController:self.goodsGrapicController];
        [self.view addSubview:_goodsGrapicController.view];
        _goodsGrapicController.view.frame = self.view.bounds;
    }
    
    if (_goodsController) {
        CGRect originFrame = self.view.bounds;
        CGRect goodsControllerFrame = originFrame;
        CGRect goodsGrapicControllerFrame = originFrame;
        
        goodsControllerFrame.origin.y -= CGRectGetHeight(originFrame);
        
        goodsGrapicControllerFrame.origin.y += CGRectGetHeight(originFrame);
        _goodsGrapicController.view.frame = goodsGrapicControllerFrame;
        
        [self transitionFromViewController:_goodsController toViewController:_goodsGrapicController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            _goodsController.view.frame = goodsControllerFrame;
            _goodsGrapicController.view.frame = originFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}



#pragma mark - Delegate

#pragma mark GoodsDetailEventDelegate

- (void)viewController:(UIViewController *)controller didTriggerEnent:(GoodsDetailEventType)event {
    switch (event) {
        case GoodsDetailEventTypePullLeft: {
            break;
        }
        case GoodsDetailEventTypePullUp: {
            [self showGoodsGrapicController];
            break;
        }
        case GoodsDetailEventTypePullDown: {
            [self showGoodsController];
            break;
        }
    }
}

#pragma mark - Public

+ (void)pushNewInstanceFromViewController:(UIViewController *__weak)fromVc goodsType:(GoodsDetailType)type {
    GoodsDetailContainer *goodsDetail = [GoodsDetailContainer new];
    goodsDetail.type = type;
    [fromVc.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - Setter


#pragma mark - Getter

- (GoodsDetailNomalViewController *)goodsController {
    if (!_goodsController) {
        GoodsDetailNomalViewController *goodsController = [GoodsDetailNomalViewController new];
        _goodsController = goodsController;
        _goodsController.delegate = self;
    }
    return _goodsController;
}

- (GoodsDetailGraphicViewController *)goodsGrapicController {
    if (!_goodsGrapicController) {
        GoodsDetailGraphicViewController *goodsGrapicController = [GoodsDetailGraphicViewController new];
        _goodsGrapicController = goodsGrapicController;
        _goodsGrapicController.delegate = self;
    }
    return _goodsGrapicController;
}






@end
