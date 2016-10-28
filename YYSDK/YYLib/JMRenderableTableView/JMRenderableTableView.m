//
//  JMRenderableTableView.m
//  JuMei
//
//  Created by yangyuan on 2016/9/29.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMRenderableTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JMRenderableTableView ()

@property (nonatomic, weak) id<UITableViewDelegate> tableViewDelegate;

@end

@implementation JMRenderableTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupContext];
    }
    return self;
}

- (void)setupContext{
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - Override

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate == self) {
        [super setDelegate:delegate];
    } else {
        _tableViewDelegate = delegate;
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    if (dataSource == self) {
        [super setDataSource:dataSource];
    }
}

#pragma mark - Public

- (void)regitsterCells:(NSArray<Class> *)cellClassArray {
    [cellClassArray enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerCell:cls];
    }];
}

- (void)reloadData:(NSArray<id<JMRenderableCellModel>> *)dataArray {
    self.dataArray = dataArray;
    [self reloadData];
}

#pragma mark - Private
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

#pragma mark - Setter

- (void)setDataArray:(NSArray<id<JMRenderableCellModel>> *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JMRenderableCellModel> model = _dataArray[indexPath.row];
    NSString *identifier = NSStringFromClass(model.cellClass);
    
    UITableViewCell<JMRenderableCell> *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        cell.delegate = self;
    }
    [cell updateWithModel:model indexPath:indexPath container:tableView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //原代理
    if ([_tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    id<JMRenderableCellModel> model = _dataArray[indexPath.row];
    NSString *identifier = NSStringFromClass(model.cellClass);
    
    if ([model.cellClass respondsToSelector:@selector(heightForModel:indexPath:container:)]) {
        return [model.cellClass heightForModel:model indexPath:indexPath container:tableView];
    }
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(UITableViewCell<JMRenderableCell> *cell) {
        [cell updateWithModel:model indexPath:indexPath container:tableView];
    }];
    
    return height;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    [_tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}


@end
