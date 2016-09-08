//
//  PullRefreshDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "PullRefreshDemo.h"
#import "UIScrollView+YYRefresh.h"

@interface PullRefreshDemo ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PullRefreshDemo


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
    [self addRefresh];
    [self.scrollView.yy_topRefresh beginRefresh];
}

- (void)viewDidLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)addRefresh {
    YYRefreshConfig *config = [YYRefreshConfig defaultConfig];
    config.textIdle = @"下拉返回商品详情";
    config.textReady = @"释放返回商品详情";
    
    [self.scrollView addYYRefreshAtPosition:YYRefreshPositionTop action:^(YYRefresh *refresh) {
        NSLog(@"YYRefreshPositionTop");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refresh endRefresh];
        });
    } config:config];
     
    [self.scrollView addYYRefreshAtPosition:YYRefreshPositionBottom action:^(YYRefresh *refresh) {
        NSLog(@"YYPullRefreshPositionBottom");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refresh endRefresh];
        });
    }];
    [self.scrollView addYYRefreshAtPosition:YYRefreshPositionRight action:^(YYRefresh *refresh) {
        NSLog(@"YYPullRefreshPositionRight");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refresh endRefresh];
        });
    }];
    [self.scrollView addYYRefreshAtPosition:YYRefreshPositionLeft action:^(YYRefresh *refresh) {
        NSLog(@"YYRefreshPositionLeft");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refresh endRefresh];
        });
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.frame = self.view.bounds;
        scrollView.backgroundColor = [UIColor lightGrayColor];
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.alwaysBounceVertical = YES;
        scrollView.bounces = YES;
        scrollView.scrollEnabled = YES;
        scrollView.contentSize = [UIScreen mainScreen].bounds.size;
        _scrollView = scrollView;
        
    }
    return _scrollView;
}

@end
