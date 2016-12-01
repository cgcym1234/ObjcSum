//
//  JMGoodsDetailGoodsContainerViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailGoodsContainerViewController.h"
#import "JMGoodsDetailContainerViewController+NavigationBar.h"

#import "JMGoodsDetail.h"
#import "JMGoodsDetailGraphicViewController.h"
#import "JMGoodsDetailGoodsViewController.h"

#import "JMGoodsDetailRefreshView.h"
#import "UIScrollView+YYRefresh.h"


static CGFloat const AnimationDuration = 0.5;


@interface JMGoodsDetailGoodsContainerViewController ()<JMGoodsDetailGraphicViewControllerDelegate>


@property (nonatomic, assign) CGRect frameVisible;
@property (nonatomic, assign) CGRect frameUp;
@property (nonatomic, assign) CGRect frameDown;

@property (nonatomic, weak) UIViewController *visibleViewController;

@property (nonatomic, weak) UIView *graphicViewControllerOriginSuperView;
@property (nonatomic, assign) CGRect graphicViewControllerOriginFrame;


@end

@implementation JMGoodsDetailGoodsContainerViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailGoodsContainerViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_goodsViewController beginAppearanceTransition:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_goodsViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_goodsViewController beginAppearanceTransition:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_goodsViewController endAppearanceTransition];
}

#pragma mark - Initialization

- (void)setupContext {
    [self setupUI];
}

- (void)setupUI {
    [self showGoodsViewController];
}

#pragma mark - Private

- (void)addGoodsViewControllerIfNeeded {
    if (!self.goodsViewController.parentViewController) {
        [self addChildViewController:_goodsViewController];
        _goodsViewController.view.frame = self.view.bounds;
        [self.view addSubview:_goodsViewController.view];
        [_goodsViewController didMoveToParentViewController:self];

        _visibleViewController = _goodsViewController;
        
        if ([_goodsViewController innerScrollView].yy_bottomRefresh) {
            return;
        }
        //添加上拉刷新控件
        YYRefreshConfig *config = [YYRefreshConfig defaultConfig];
        config.textIdle = nil;
        config.textReady = nil;
        config.parkVisible = NO;
        
        JMGoodsDetailRefreshView *footer = [JMGoodsDetailRefreshView instanceFromNib];
        
        __weak __typeof(self) weakSelf = self;
        [[_goodsViewController innerScrollView] addYYRefreshAtPosition:YYRefreshPositionBottom config:config customView:footer action:^(YYRefresh *refresh) {
            
            [refresh endRefresh];
            [weakSelf showGrapicViewController];
        } ];
    }
}

- (void)addGrapicViewControllerIfNeeded {
    //因为用是复用一个Controller，所以直接改变frame
    _graphicViewControllerOriginFrame = _graphicViewController.view.frame;
//    [_graphicViewController.view removeFromSuperview];
//    [self.view addSubview:_graphicViewController.view];
    _graphicViewController.view.frame = self.frameDown;
    
    if ([_graphicViewController innerScrollView].yy_topRefresh) {
        return;
    }
    YYRefreshConfig *config = [YYRefreshConfig defaultConfig];
    config.textIdle = @"下拉返回宝贝详情";
    config.textReady = @"下拉返回宝贝详情";
    config.parkVisible = NO;
    config.viewHeight = 64;
    JMGoodsDetailRefreshView *header = [JMGoodsDetailRefreshView instanceFromNib];
    __weak __typeof(self) weakSelf = self;
    [[_graphicViewController innerScrollView] addYYRefreshAtPosition:YYRefreshPositionTop config:config customView:header action:^(YYRefresh *refresh) {
        [refresh endRefresh];
        
        if (!refresh.hidden) {
            [weakSelf showGoodsViewController];
        }
    }];
}

- (void)setGrapicViewControllerBack {
//    [_graphicViewController.view removeFromSuperview];
    _graphicViewController.view.frame = _graphicViewControllerOriginFrame;
//    [_graphicViewControllerOriginSuperView addSubview:_graphicViewController.view];
}

#pragma mark - Transition

- (void)showGoodsViewController {
    [self addGoodsViewControllerIfNeeded];
    
    if (_visibleViewController == _graphicViewController) {
        [_goodsViewController beginAppearanceTransition:YES animated:YES];
        [_graphicViewController beginAppearanceTransition:NO animated:YES];
        
        _visibleViewController = _goodsViewController;
        [_graphicViewController setBackToTopButtonHidden:YES];
        [UIView animateWithDuration:AnimationDuration animations:^{
            _goodsViewController.view.frame = self.frameVisible;
            _graphicViewController.view.frame = self.frameDown;
        } completion:^(BOOL finished) {
            [_goodsViewController endAppearanceTransition];
            [_graphicViewController endAppearanceTransition];
            
            [_goodsDetailManager switchNavigationTitle];
            [_goodsDetailManager setHorizontalScrollEnable:YES];
            
            //如果当前显示的不是图文详情，隐藏刷新控件
            [_graphicViewController innerScrollView].yy_topRefresh.hidden = YES;
            _graphicViewController.delegate = nil;
            
            //放回原位置
            [self setGrapicViewControllerBack];
        }];
    }
}

- (void)showGrapicViewController {
    [self addGrapicViewControllerIfNeeded];
    
    if (_visibleViewController == _goodsViewController) {
        [_goodsViewController beginAppearanceTransition:NO animated:YES];
        [_graphicViewController beginAppearanceTransition:YES animated:YES];
        _visibleViewController = _graphicViewController;
        [[_graphicViewController innerScrollView] setContentOffset:CGPointZero animated:NO];
        [_goodsDetailManager setHorizontalScrollEnable:NO];
        [UIView animateWithDuration:AnimationDuration animations:^{
            _graphicViewController.view.frame = self.frameVisible;
            _goodsViewController.view.frame = self.frameUp;
        } completion:^(BOOL finished) {
            [_goodsViewController endAppearanceTransition];
            [_graphicViewController endAppearanceTransition];
            
            [_goodsDetailManager switchNavigationTitle];
            [_graphicViewController innerScrollView].yy_topRefresh.hidden = NO;
            [_graphicViewController setBackToTopButtonHidden:NO];
            _graphicViewController.delegate = self;
        }];
    }
}

#pragma mark - JMGoodsDetailGraphicViewControllerDelegate

- (void)jmGoodsDetailGraphicViewControllerDidClickBackToTopButton:(JMGoodsDetailGraphicViewController *)graphicViewController {
    
    [[self.goodsViewController innerScrollView] setContentOffset:CGPointZero animated:NO];
    [self showGoodsViewController];
}

#pragma mark - Setter

- (void)setGraphicViewController:(JMGoodsDetailGraphicViewController *)graphicViewController {
    _graphicViewController = graphicViewController;
}

#pragma mark - Getter

- (JMGoodsDetailGoodsViewController *)goodsViewController {
    if (!_goodsViewController) {
        _goodsViewController = ({
            JMGoodsDetailGoodsViewController *vc = [JMGoodsDetailGoodsViewController instanceFromStoryboard];
            vc;
        });
    }
    return _goodsViewController;
}

//- (JMGoodsDetailGraphicViewController *)graphicViewController {
//    if (!_graphicViewController) {
//        _graphicViewController = ({
//            JMGoodsDetailGraphicViewController *vc = [JMGoodsDetailGraphicViewController instanceFromStoryboard];
//            vc;
//        });
//    }
//    return _graphicViewController;
//}

- (CGRect)frameVisible {
    return self.view.bounds;
}

- (CGRect)frameUp {
    return CGRectOffset(self.frameVisible, 0, - self.frameVisible.size.height);
}

- (CGRect)frameDown {
    return CGRectOffset(self.frameVisible, 0, self.frameVisible.size.height);
}




@end


