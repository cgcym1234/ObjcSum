//
//  YYPageController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/28.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYPageController.h"
#import <objc/runtime.h>

@interface UIViewController (Index)

@property (nonatomic, assign) NSInteger index;

@end


static char kIndex;

@implementation UIViewController (Index)

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &kIndex, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    NSNumber *index = objc_getAssociatedObject(self, &kIndex);
    return index != nil ? index.integerValue : -1;
}

@end

@interface YYPageController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation YYPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEnvironment];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIPageViewController *)pageController {
    if (!_pageController) {
        UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageController.dataSource = self;
        pageController.delegate = self;
        [self addChildViewController:pageController];
//        pageController.view.frame = self.view.bounds;
        [self.view addSubview:pageController.view];
        [pageController didMoveToParentViewController:self];
        _pageController = pageController;
    }
    return _pageController;
}


#pragma mark - Private

- (void)setEnvironment {
    _totalPages = 0;
    _currentPage = 0;
    
    UIViewController *initialVC = [self getInitialController] ?: [UIViewController new];
    [self.pageController setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (UIViewController *)getInitialController {
    _totalPages = [self.delegate yyPageControllerNumberOfControllers];
    return [self getControllerAtIndex:0];
}

- (UIViewController *)getControllerAtIndex:(NSInteger)index {
    if (index >= 0 && index <= _totalPages - 1) {
        UIViewController *vc = [self.delegate yyPageController:self controllerAtIndex:index];
        vc.index = index;
        return vc;
    }
    return nil;
}

- (void)setControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [self getControllerAtIndex:index];
    if (vc) {
        [self.pageController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
}

#pragma mark - Public
- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    
    if (currentPage >= 0 && currentPage <= _totalPages - 1) {
        _currentPage = currentPage;
        [self setControllerAtIndex:currentPage];
    }
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = viewController.index;
    if (index <= 0) {
        return nil;
    }
    return [self getControllerAtIndex:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = viewController.index;
    if (index >= _totalPages-1) {
        return nil;
    }
    return [self getControllerAtIndex:++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([self.delegate respondsToSelector:@selector(yyPageController:didScrollToPage:)]) {
            [self.delegate yyPageController:self didScrollToPage:_currentPage];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _currentPage = pendingViewControllers.firstObject.index;
}

@end
