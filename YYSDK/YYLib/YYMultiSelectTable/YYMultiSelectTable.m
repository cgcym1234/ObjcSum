//
//  YYMultiSelectTable.m
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "YYMultiSelectTable.h"
#import "YYMultiSelectCell.h"
#import "YYMultiSelectModel.h"
#import "YYDim.h"

#pragma mark - Consts

#define BottomLineColor [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1]

static NSInteger const HeightForCommonCell = 40;
static NSInteger const MaxCells = 5;

#pragma mark  Keys
static NSString * const IdentifierCell = @"YYMultiSelectCell";

@interface YYMultiSelectTable ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation YYMultiSelectTable

- (void)awakeFromNib {
    _cancelButton.tag = 0;
    _confirmButton.tag = 1;
    _selectedIndexNumber = [NSMutableSet new];
    _titleLabel.userInteractionEnabled = YES;
    _tableView.rowHeight = HeightForCommonCell;
    [_tableView registerNib:[UINib nibWithNibName:IdentifierCell bundle:nil] forCellReuseIdentifier:IdentifierCell];
    self.backgroundColor = [UIColor clearColor];
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, BottomLineColor.CGColor);
//    CGContextMoveToPoint(context, 0, 60);
//    CGContextAddLineToPoint(context, self.frame.size.width, 60);
//    CGContextStrokePath(context);
//}

- (void)dealloc {
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [YYDim dismss];
}

- (IBAction)didClicedButton:(UIButton *)sender {
    if (_didClickedBlock) {
        _didClickedBlock(self, sender.tag);
    }
    [YYDim dismss];
}

#pragma mark - Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell forIndexPath:indexPath];
    [cell updateUI:self.dataArr[indexPath.row] atIndexpath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYMultiSelectModel *item = self.dataArr[indexPath.row];
    item.checked = !item.checked;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Private



#pragma mark - Public

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)showWithTitle:(NSString *)title dataArr:(NSArray *)dataArr {
    self.title = title;
    self.dataArr = dataArr;
    
    [self show];
}

- (void)show {
    CGFloat tableHeight = MIN(MaxCells, _dataArr.count)*HeightForCommonCell;
    self.tableViewHeight.constant = tableHeight;
    [self.tableView reloadData];
    [YYDim showView:self];
}

+ (instancetype)showWithTitle:(NSString *)title dataArr:(NSArray *)dataArr {
    YYMultiSelectTable *view = [YYMultiSelectTable instanceFromNib];
    [view showWithTitle:title dataArr:dataArr];
    return view;
}
@end
