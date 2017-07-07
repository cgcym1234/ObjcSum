//
//  YYAlertTable.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertTable.h"
#import "YYAlertTableCell.h"
#import "YYAlertTableTitleCell.h"
#import "YYDim.h"

@interface YYAlertTable ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;

@end

#pragma mark - Consts
static NSInteger const HeightForTitle = 60;
static NSInteger const HeightForCommonCell = 49;
static NSInteger const MiniCells = 4;

#pragma mark  Keys
static NSString * const IdentifierCell = @"YYAlertTableCell";
static NSString * const IdentifierTitle = @"YYAlertTableTitleCell";


@implementation YYAlertTable

#pragma mark - Life cycle
- (void)awakeFromNib {
    [self.tableView registerClass:[YYAlertTableTitleCell class] forCellReuseIdentifier:IdentifierTitle];
    [self.tableView registerClass:[YYAlertTableCell class] forCellReuseIdentifier:IdentifierCell];
    self.title = @"标题";
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
}

#pragma mark - Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? HeightForTitle : HeightForCommonCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = indexPath.row == 0 ? IdentifierTitle : IdentifierCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        if (_didClickedBlock) {
            _didClickedBlock(self, indexPath.row-1);
        }
        [YYDim dismss];
    }
}

#pragma mark - Getters and Setters


#pragma mark - Methods


#pragma mark Private
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [YYDim dismss];
}

#pragma mark Public

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setTextArray:(NSArray *)textArray {
    _textArray = textArray;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:textArray.count+1];
    [arr addObject:_title];
    [arr addObjectsFromArray:textArray];
    _dataArr = arr;
}

- (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry {
    self.title = title;
    self.textArray = textArry;
    
    return [self show];
}

- (instancetype)show {
    CGFloat tableHeight = 1*HeightForTitle + MIN(MiniCells, _textArray.count)*HeightForCommonCell;
    [self.tableView reloadData];
    [YYDim showView:self];
    return self;
}

+ (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry {
    YYAlertTable *alertTable = [YYAlertTable instanceFromNib];
    return [alertTable showWithTitle:title textArry:textArry];
}

@end
