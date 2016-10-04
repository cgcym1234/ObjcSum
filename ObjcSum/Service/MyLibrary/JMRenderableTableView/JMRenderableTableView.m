//
//  JMRenderableTableView.m
//  JuMei
//
//  Created by yangyuan on 2016/9/29.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMRenderableTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"

@implementation JMRenderableTableView


/**
 刷新数据期间，将UITableViewDelegate设置为自己，用于计算高度
 刷新完再置为原来的代理
 */
- (void)reloadData {
    id<UITableViewDelegate> originDelegate = self.delegate;
    self.dataSource = self;
    self.delegate = self;
    [super reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.delegate = originDelegate;
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JMRenderableCellModel> model = _dataArray[indexPath.row];
    NSString *identifier = NSStringFromClass(model.cellClass);
    UITableViewCell<JMRenderableCell> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        cell.delegate = self;
    }
    [cell updateWithCellModel:model indexPath:indexPath containerView:tableView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<JMRenderableCellModel> model = _dataArray[indexPath.row];
    NSString *identifier = NSStringFromClass(model.cellClass);
    [self registerCell:model.cellClass];
    
    if ([model respondsToSelector:@selector(cellHeight)]) {
        return [model cellHeight];
    }
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier:identifier configuration:^(UITableViewCell<JMRenderableCell> *cell) {
        [cell updateWithCellModel:model indexPath:indexPath containerView:tableView];
    }];
    
    return height;
}

//注册cell
- (void)registerCell:(Class)cellClass {
    NSString *identifier = NSStringFromClass(cellClass);
    UINib *cellNib = nil;
    @try {
        cellNib = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].firstObject;
    } @catch (NSException *exception) {
        cellNib = nil;
    }
    
    //优先判断是否有xib文件
    if (cellNib) {
        [self registerNib: [UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

@end
