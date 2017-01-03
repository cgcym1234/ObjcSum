//
//  GoodsDetailNomalViewController.m
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetailNomalViewController.h"
#import "DemoCellModel.h"
#import "JMRenderableTableView.h"

#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "DemoCellModel2.h"
#import "DemoCell.h"
#import "DemoCell2.h"

#define BottomContainerHeight (44)

@implementation GoodsDetailNomalViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setContext];
}

- (void)setContext {
    [self setupUI];
    [self requestData];
}

- (void)setupUI {
    self.title = @"商品详情";
    
    JMRenderableTableView *tableView = [[JMRenderableTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"DemoCell" bundle:nil] forCellReuseIdentifier:@"DemoCell"];
    [tableView registerClass:DemoCell2.class forCellReuseIdentifier:@"DemoCell2"];
    
    UIView *bottomContainer = [UIView new];
    bottomContainer.backgroundColor = [UIColor redColor];
    _bottomContainer = bottomContainer;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomContainer];
    
    
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


- (void)requestData {
    [self requestData:NO];
}

- (void)requestData:(BOOL)appendData {
    self.dataArray = [NSMutableArray<JMRenderableCellModel> new];
    
    NSArray *texts = @[@"test1", @"test2test2test2test2test2test2test2test2test2test2test2test2test2", @"test3", @"test4test2test2test2test2", @"test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5", @"test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6", @"test7", @"test8", @"test9test9test9test9test9",@"101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010", @"111111111111111111111111111111111"];
    
    DemoCellModel2 *model = [DemoCellModel2 new];
    model.text = @"DemoCellModel2";
    [self.dataArray addObject:model];
    
    for (NSString *text in texts) {
        DemoCellModel *model = [DemoCellModel new];
        model.text = text;
        [self.dataArray addObject:model];
    }
    
    self.tableView.dataArray = self.dataArray;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
