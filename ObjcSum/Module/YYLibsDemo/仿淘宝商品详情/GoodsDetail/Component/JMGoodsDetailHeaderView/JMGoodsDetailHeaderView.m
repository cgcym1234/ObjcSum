//
//  JMGoodsDetailHeaderView.m
//  JuMei
//
//  Created by yangyuan on 2016/11/2.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailHeaderView.h"


@interface JMGoodsDetailHeaderView ()

//当前显示的View photoHeaderView 或 blankHeaderView
@property (nonatomic, weak) UIView *showingView;

@end

@implementation JMGoodsDetailHeaderView

#pragma mark - Initialization

+ (instancetype)instanceWithViewController:(JMBaseViewController *)containerViewController {
    return [[JMGoodsDetailHeaderView alloc] initWithViewController:containerViewController];
}

- (instancetype)initWithViewController:(JMBaseViewController *)containerViewController{
    if (self = [super initWithFrame:CGRectZero]) {
        self.containerViewController = containerViewController;
        [self setupContext];
    }
    return self;
}

- (void)setupContext{
    self.clipsToBounds = YES;
}

#pragma mark - Public


- (void)scrollingWithView:(UIScrollView *)scrollView {
    
}


#pragma mark - Private

- (void)notifyHeightChanged {
    if ([_delegate respondsToSelector:@selector(jmGoodsDetailHeaderViewHeightDidChanged:)]) {
        [_delegate jmGoodsDetailHeaderViewHeightDidChanged:self];
    }
}

@end
