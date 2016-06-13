//
//  GoodsDetailBaseViewController.m
//  MLLCustomer
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetailBaseViewController.h"

#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DemoCell.h"

#define BottomContainerHeight (44)

@interface GoodsDetailBaseViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomContainer;

@end

@implementation GoodsDetailBaseViewController

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setContext {
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.title = @"商品详情";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    
    UIView *bottomContainer = [UIView new];
    bottomContainer.backgroundColor = [UIColor redColor];
    _bottomContainer = bottomContainer;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomContainer];
    
    [self registerCells];
    
    UIView *superview = self.view;
    
    [bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(BottomContainerHeight));
        make.left.equalTo(superview.mas_left).offset(0);
        make.right.equalTo(superview.mas_right).offset(0);
        make.bottom.equalTo(superview.mas_bottom).offset(0);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(0);
        make.left.equalTo(superview.mas_left).offset(0);
        make.right.equalTo(superview.mas_right).offset(0);
        make.bottom.equalTo(bottomContainer.mas_top).offset(0);
    }];
}

- (void)registerCells {
    NSArray *cellClasses = @[
                             DemoCell.class,
                             ];
    
    for (Class cls in cellClasses) {
        NSString *identifier = NSStringFromClass(cls);
        UINib *cellNib = [UINib nibWithNibName:identifier bundle:nil];
        if (cellNib) {
            [_tableView registerNib:cellNib forCellReuseIdentifier:identifier];
        } else {
            [_tableView registerClass:cls forCellReuseIdentifier:identifier];
        }
    }
}

- (void)loadData {
}


#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<GoodsDetailModel> model = _dataArray[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:model.cellIdentifier configuration:^(UITableViewCell<GoodsDetailCellDelegate> *cell) {
        [cell updateWithModel:model atIndexPath:indexPath inView:tableView];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<GoodsDetailModel> model = _dataArray[indexPath.row];
    UITableViewCell<GoodsDetailCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier forIndexPath:indexPath];
    [cell updateWithModel:model atIndexPath:indexPath inView:tableView];
    return cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height + GoodsDetailEventOffset) {
        [self triggerEvent:GoodsDetailEventTypePullUp];
    }
}

- (void)triggerEvent:(GoodsDetailEventType)event {
    if ([_delegate respondsToSelector:@selector(viewController:didTriggerEnent:)]) {
        [_delegate viewController:self didTriggerEnent:event];
    }
}

#pragma mark - Public

- (void)reloadData {
    [_tableView reloadData];
}


#pragma mark - Setter


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        
    }
    return _tableView;
}

- (UIView *)bottomContainer {
    if (!_bottomContainer) {
        
    }
    return _bottomContainer;
}




@end

















