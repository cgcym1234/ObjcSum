//
//  JMGoodsDetailPageController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailPageController.h"
#import "UIViewController+Extension.h"



@interface JMGoodsDetailPageController ()
<YYPageViewControllerDelegate>

@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;
@end

@implementation JMGoodsDetailPageController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

#pragma mark - Initialization

- (void)setupContext {
    self.delegate = self;
}

#pragma mark - Public

- (void)setSelectedControlerIndex:(NSUInteger)index notify:(BOOL)notify {
    [self scrollToPage:index animated:YES notify:notify];
}

- (BOOL)isScrolling {
    return self.scrollView.tracking || self.scrollView.decelerating || self.scrollView.dragging;
}

- (void)setScrollEnabled:(BOOL)enable {
    self.scrollView.scrollEnabled = enable;
}

#pragma mark - Delegate

#pragma mark YYPageViewControllerDelegate

- (NSInteger)numberOfControllersInYYPageViewController:(YYPageViewController *)pageViewController {
    return _viewControllers.count;
}

- (UIViewController *)YYPageViewController:(YYPageViewController *)pageViewController controllerAtPage:(NSInteger)index {
    UIViewController *vc = _viewControllers[index];
//    vc.pageIndex = index;
    return vc;
}

- (void)YYPageViewController:(YYPageViewController *)pageViewController didScrollToPage:(NSInteger)page prevPage:(NSInteger)prevPage {
    if (self.indexChangeBlock) {
        self.indexChangeBlock(pageViewController.currentViewController, page);
    }
}

#pragma mark - Setter

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self reloadData];
}

#pragma mark - Getter





@end

