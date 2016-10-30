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
    // 兼容系统pop手势 / FDFullscreenPopGesture
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0 && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
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
    [self setupUI];
}

- (void)setupUI {
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

- (BOOL)isValidPage:(NSInteger)page {
    return page >= 0 && page < self.childViewControllers.count;
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (_currentPage == page) {
        return;
    }
    
    if (![self isValidPage:page]) {
        return;
    }
    _prevPage = _currentPage;
    _currentPage = page;
    CGFloat x = CGRectGetWidth(self.scrollView.bounds) * page;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:animated];
}


#pragma mark - YYScrollViewDelegate

- (void)scrollViewDidEndDragging:(YYScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(YYScrollView *)scrollView {
    NSInteger page = self.page;
    if (_currentPage != page) {
        if ([_delegate respondsToSelector:@selector(yyPageViewController:didScrollToPage:prevPage:)]) {
            _prevPage = _currentPage;
            _currentPage = page;
            [_delegate yyPageViewController:self didScrollToPage:page prevPage:_prevPage];
        }
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

#pragma mark - Setter

- (void)setCurrentPage:(NSInteger)currentPage {
    [self scrollToPage:currentPage animated:YES];
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
    if (![self isValidPage:_currentPage]) {
        return nil;
    }
    return self.childViewControllers[_currentPage];
}

- (NSInteger)page {
    NSInteger page = (NSInteger)(_scrollView.contentOffset.x/_scrollView.bounds.size.width)%_totalPages;
    return page;
}


@end

