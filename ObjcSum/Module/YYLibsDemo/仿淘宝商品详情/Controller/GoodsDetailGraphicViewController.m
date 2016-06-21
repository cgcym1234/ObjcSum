//
//  GoodsDetailGraphicViewController.m
//  MLLCustomer
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetailGraphicViewController.h"
#import "Masonry.h"


static NSString * const KeyCell = @"KeyCell";

static NSString * const ToViewController = @"ToViewController";


@interface GoodsDetailGraphicViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GoodsDetailGraphicViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setContext {
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.title = @"商品详情";
    [self.view addSubview:self.tableView];
    
    UIView *superview = self.view;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(0);
        make.left.equalTo(superview.mas_left).offset(0);
        make.right.equalTo(superview.mas_right).offset(0);
        make.bottom.equalTo(superview.mas_bottom).offset(0);
    }];
}


- (void)loadData {
    [self loadData:NO];
}

- (void)loadData:(BOOL)appendData {
    _dataArray = @[@"test1", @"test2", @"test2", @"test2", @"test2", @"test2", @"test2", @"test2", @"test2", @"test2"];
}

- (void)updateUI:(NSDictionary *)jsonDic {
    
}

- (void)callback:(id)obj {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ToViewController]) {
        
    }
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeyCell forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (-scrollView.contentOffset.y >= GoodsDetailEventOffset) {
        [self triggerEvent:GoodsDetailEventTypePullDown];
    }
}

- (void)triggerEvent:(GoodsDetailEventType)event {
    if ([_delegate respondsToSelector:@selector(viewController:didTriggerEnent:)]) {
        [_delegate viewController:self didTriggerEnent:event];
    }
}

#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KeyCell];
        _tableView = tableView;
    }
    return _tableView;
}



@end

