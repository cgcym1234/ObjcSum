//
//  YYPageViewController.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYPageViewController.h"

@interface YYScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@implementation YYScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 兼容系统pop手势
    if (self.contentOffset.x <= 0 &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 系统pop手势优先
    if (self.contentOffset.x <= 0 &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end

@interface YYPageViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) YYScrollView *scrollView;

@end

@implementation YYPageViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupContext];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.view.bounds, self.scrollView.bounds)) {
        [self layoutViewControllers];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Override


#pragma mark - Initialization

- (void)__setupContext {
    [self.view addSubview:self.scrollView];
}

#pragma mark - Callback

#pragma mark - Public

- (void)reloadData {
    [self removeViewControllers];
    [self addViewContrllers];
    [self layoutViewControllers];
}

#pragma mark - Private

- (void)removeViewControllers {
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }];
    
    _scrollView.contentSize = CGSizeZero;
}

- (void)addViewContrllers {
    _totalPages = [self.delegate numberOfControllersInYYPageViewController:self];
    
    for (int i = 0; i < _totalPages; i++) {
        UIViewController *vc = [self.delegate yyPageViewController:self controllerAtPage:i];
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
}

- (void)layoutViewControllers {
    _scrollView.frame = self.view.bounds;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    CGFloat contentWidth = 0;
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(contentWidth, 0, width, height);
        contentWidth += width;
    }
    
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
}

#pragma mark -

- (BOOL)isValidPage:(NSInteger)page {
    return page >= 0 && page < self.childViewControllers.count;
}

- (UIViewController *)viewControllerAtPage:(NSInteger)page {
    if (![self isValidPage:page]) {
        return nil;
    }
    return self.childViewControllers[page];
}

#pragma mark -

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated notify:(BOOL)notify {
    if (_currentPage == page) {
        return;
    }
    
    if (![self isValidPage:page]) {
        return;
    }
    
    CGFloat x = CGRectGetWidth(self.scrollView.bounds) * page;
    
    [self willScrollToPage:page prevPage:_currentPage animated:animated notify:notify];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = CGPointMake(x, 0);
        } completion:^(BOOL finished) {
            [self didScrollToPage:page prevPage:_currentPage animated:animated notify:notify];
        }];
    } else {
        _scrollView.contentOffset = CGPointMake(x, 0);
        [self didScrollToPage:page prevPage:_currentPage animated:animated notify:notify];
    }
}

- (void)willScrollToPage:(NSInteger)page prevPage:(NSInteger)prevPage animated:(BOOL)animated notify:(BOOL)notify {
    if (prevPage == page) {
        return;
    }
    
    UIViewController *prevVc = [self viewControllerAtPage:_prevPage];
    UIViewController *currentVc = [self viewControllerAtPage:_currentPage];
    [prevVc viewWillDisappear:animated];
    [currentVc viewWillAppear:animated];
    
    if (notify && [_delegate respondsToSelector:@selector(yyPageViewController:willScrollToPage:prevPage:)]) {
        [_delegate yyPageViewController:self willScrollToPage:page prevPage:_prevPage];
    }
}

- (void)didScrollToPage:(NSInteger)page prevPage:(NSInteger)prevPage animated:(BOOL)animated notify:(BOOL)notify {
    if (prevPage == page) {
        return;
    }
    _prevPage = prevPage;
    _currentPage = page;
    
    UIViewController *prevVc = [self viewControllerAtPage:prevPage];
    UIViewController *currentVc = [self viewControllerAtPage:page];
    [prevVc viewDidDisappear:animated];
    [currentVc viewDidAppear:animated];
    
    if (notify && [_delegate respondsToSelector:@selector(yyPageViewController:didScrollToPage:prevPage:)]) {
        [_delegate yyPageViewController:self didScrollToPage:page prevPage:prevPage];
    }
}

#pragma mark - YYScrollViewDelegate

- (void)scrollViewDidEndDragging:(YYScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger page = self.page;
    if (_currentPage != page) {
        [self willScrollToPage:page prevPage:_currentPage animated:YES notify:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(YYScrollView *)scrollView {
    NSInteger page = self.page;
    if (_currentPage != page) {
        [self didScrollToPage:page prevPage:_currentPage animated:YES notify:YES];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

#pragma mark - Setter

- (void)setCurrentPage:(NSInteger)currentPage {
    [self scrollToPage:currentPage animated:YES notify:NO];
}

#pragma mark - Getter

- (YYScrollView *)scrollView {
    if (!_scrollView) {
        YYScrollView *scrollView = [[YYScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.clipsToBounds = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIViewController *)currentViewController {
    return [self viewControllerAtPage:_currentPage];
}

- (NSInteger)page {
    CGRect visibleBounds = _scrollView.bounds;
    NSInteger index = (NSInteger) (floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    return index;
}


@end

