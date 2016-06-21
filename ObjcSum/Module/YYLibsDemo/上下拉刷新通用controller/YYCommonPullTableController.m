//
//  YYCommonPullTableController.m
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYCommonPullTableController.h"
#import "YYCommonList.h"

#import "UIViewController+NoDataTip.h"
#import "YYHud.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

#pragma mark - Consts


static NSString * const CommonCellIdentifier = @"CommonCellIdentifier";

static NSString * const ToViewController = @"ToViewController";


@interface YYCommonPullTableController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YYCommonList *list;

@end

@implementation YYCommonPullTableController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
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

#pragma mark - Initialize

- (void)initialize {
    self.title = @"";
    
    _list = [YYCommonList new];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    
    [self addRefreashView];
    [self loadData];
}

- (void)addRefreashView {
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    //上拉加载更多
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:YES];
    }];
//    [self.tableView addPullRefreshAtPosition:YYPullRefreshPositionTop action:^(YYPullRefresh *refresh) {
//        NSLog(@"YYPullRefreshPositionTop");
//    }];
}

#pragma mark - Network

- (void)stopLoading
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)loadData
{
    _list.currentPage = 0;
    [self loadData:NO];
}

- (void)loadData:(BOOL)appendData {
    
    if (appendData) {
        if (_list.lastPage) {
            [self stopLoading];
            return;
        }
        _list.currentPage++;
    }
    
//    [YYHud show:@"努力加载中"];
//    [HttpManager requestTasksListWithAudit:@"N" startPage:[@(_list.currentPage) stringValue] success:^(TaskList *taskList) {
//        if (appendData) {
//            [self.taskList appendList:taskList];
//        } else {
//            self.taskList = taskList;
//        }
//        
//        [self reloadData];
//        [self stopLoading];
//        [YYHud dismiss];
//    } failure:^(NSString *errorString) {
//        [YYHud showTip:errorString];
//        [self stopLoading];
//    }];
}

- (void)reloadData {
    [self.tableView reloadData];
    if (_list.items.count == 0) {
        [self noDataTipShow:@"暂时没有数据！"];
    } else {
        [self noDataTipDismiss];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:CommonCellIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell<YYCommonCellProtocol> *cell) {
        [cell updateWithItem:_list.items[indexPath.row] inTableView:tableView atIndexpath:indexPath];
    }];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell<YYCommonCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier forIndexPath:indexPath];
    [cell updateWithItem:_list.items[indexPath.row] inTableView:tableView atIndexpath:indexPath];
    //    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:ToViewController sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    if ([segueIdentifier isEqualToString:ToViewController]) {
        
    }
}

@end