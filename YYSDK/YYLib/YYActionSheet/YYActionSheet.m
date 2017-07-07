//
//  YYActionSheet.m
//  ObjcSum
//
//  Created by yangyuan on 2017/6/7.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "YYActionSheet.h"
#import "YYActionSheetCell.h"
#import "UIView+Frame.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 60;

static NSString * const TitleCell = @"YYActionSheetCell";
static NSString * const ItemCell = @"YYActionSheetCell";

@interface YYActionSheet ()

@property (nonatomic, strong) NSArray<YYActionSheetItem *> *dataArray;

@end

@implementation YYActionSheet


#pragma mark - Initialization

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

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:self.tableView];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public

+ (instancetype)showWithTitle:(NSString *)title texts:(NSArray *)texts action:(YYActionSheetDidClickedBlock)action {
    return [self showWithTitle:title texts:texts destructiveLast:NO action:action];
}

+ (instancetype)showWithTitle:(NSString *)title texts:(NSArray *)texts destructiveLast:(BOOL)destructive action:(YYActionSheetDidClickedBlock)action {
    if (texts.count == 0) {
        return nil;
    }
    
    NSMutableArray<YYActionSheetItem *> *arr = [NSMutableArray new];
    [texts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[YYActionSheetItem instanceWithTitle:obj]];
    }];
    if (destructive) {
        arr.lastObject.titleColor = kREDTEXTCOLOR;
    }
    
    return [self showWithTitle:title items:arr action:action];
}

+ (instancetype)showWithTitle:(NSString *)title items:(NSArray<YYActionSheetItem *> *)items action:(YYActionSheetDidClickedBlock)action {
    if (items.count == 0) {
        return nil;
    }
    YYActionSheet *view = [YYActionSheet new];
    return [view showWithTitle:title items:items action:action];
}

- (instancetype)showWithTitle:(NSString *)title items:(NSArray<YYActionSheetItem *> *)items action:(YYActionSheetDidClickedBlock)action {
    self.dataArray = items;
    self.didClickedBlock = action;
    [self reloadData];
    [self show];
    return self;
}

- (void)reloadData {
    [_tableView reloadData];
}

- (instancetype)show {
    _tableView.height = _dataArray.count * HeightForCommonCell;
    _tableView.width = self.width;
    _tableView.bottom = self.height;
    
    return self;
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - Private


#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.row == 0 ? HeightForTitle : HeightForCommonCell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = ItemCell;
    YYActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        if (_didClickedBlock) {
            _didClickedBlock(self, indexPath.row);
        }
        [self dismiss];
    }
}

#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView new];
        tableView.rowHeight = HeightForCommonCell;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.layoutMargins = UIEdgeInsetsZero;
        [tableView registerNib:[UINib nibWithNibName:TitleCell bundle:nil] forCellReuseIdentifier:TitleCell];
        [tableView registerNib:[UINib nibWithNibName:ItemCell bundle:nil] forCellReuseIdentifier:ItemCell];
    
        _tableView = tableView;
    }
    return _tableView;
}

@end
