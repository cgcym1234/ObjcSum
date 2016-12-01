//
//  JMGoodsDetailGoodsViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailGoodsViewController.h"
#import "JMGoodsDetail.h"

#import "JMGoodsDetailHeaderView.h"

@interface JMGoodsDetailGoodsViewController ()

@property (nonatomic, strong) JMGoodsDetailHeaderView *tableHeadView;

@property(nonatomic, strong) NSMutableArray *cellObjects; ///< 详情页tableView的CellObjects

@end

@implementation JMGoodsDetailGoodsViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailGoodsViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}


#pragma mark - Initialization

- (void)setupContext {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public

- (UIScrollView *)innerScrollView {
    return self.tableView;
}

//默认的图片，用于加入购物车等动画
- (UIImage *)defaultGoodsImage {
    return _tableHeadView.defaultGoodsImage;
}

//当前选中的image，用于分享等
- (UIImage *)currentGoodsImage {
    return _tableHeadView.currentGoodsImage;
}

- (void)reloadAll {
    
    [self reloadHeader];
    [self reloadList];
}

- (void)reloadList {
    
    
    [self.tableView reloadData];
}

#pragma mark - Delegate

#pragma mark JMGoodsDetailHeaderViewDelegate

- (void)jmGoodsDetailHeaderViewHeightDidChanged:(JMGoodsDetailHeaderView *)headerView {
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = headerView;
}

- (void)jmGoodsDetailHeaderViewDidScrolledOverLastImage:(JMGoodsDetailHeaderView *)headerView {
    [self.goodsDetailManager changeToPage:JMGoodsDetailPageGraphic];
}

#pragma mark - Getter

- (JMGoodsDetailHeaderView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [JMGoodsDetailHeaderView instanceWithViewController:self];
        _tableHeadView.delegate = self;
    }
    return _tableHeadView;
}


@end

