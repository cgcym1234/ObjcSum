//
//  YYAlertTable.m
//  tttt
//
//  Created by sihuan on 15/12/22.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYSimpleAlertTable.h"
#import "YYDim.h"

#pragma mark - Consts

static NSInteger const HeightForCommonCell = 44;
static NSInteger const MaxCells = 5;
static NSInteger const Margin = 40;

#pragma mark  Keys
static NSString * const IdentifierCell = @"YYAlertTableCell";
static NSString * const IdentifierTitle = @"YYAlertTableTitleCell";

@interface YYSimpleAlertTable ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation YYSimpleAlertTable

#pragma mark - Life cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _width = 0;
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = HeightForCommonCell;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell];
        cell.textLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        if ([cell performSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
    }
    cell.textLabel.text = _textArry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_didClickedBlock) {
        _didClickedBlock(self, indexPath.row);
    }
    [YYDim dismss];
}

#pragma mark - Public

- (void)setTextArry:(NSArray *)textArry {
    _textArry = textArry;
    CGFloat width = _width <= 0 ? CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * Margin : _width;
    CGFloat heigth = MIN(textArry.count * HeightForCommonCell, MaxCells *HeightForCommonCell);
    self.bounds = CGRectMake(0, 0, width, heigth);
}

+ (instancetype)showWithTextArry:(NSArray *)textArry {
    YYSimpleAlertTable *alertTable = [self sharedInstance];
    [alertTable showWithTextArry:textArry];
    return alertTable;
}

- (void)showWithTextArry:(NSArray *)textArry {
    self.textArry = [textArry copy];
    [self show];
}

- (void)show {
    [self reloadData];
    [YYDim showView:self animation:YYDimAnimationFade];
}

@end
