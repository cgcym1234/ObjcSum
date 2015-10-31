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

@interface YYAlertTable ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

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
        [self dismss];
    }
    
}

#pragma mark - Getters and Setters


#pragma mark - Methods


#pragma mark Private
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (instancetype)show {
    if (!self.superview) {
#pragma mark - 找到当前显示的window
        NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == [UIScreen mainScreen];
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
        
        [self showAnimation];
    } else {
        [self.superview bringSubviewToFront:self];
    }
    
    return self;
}

- (void)showAnimation {
    [self.tableView reloadData];
        self.tableView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.1f, 1.1f));
    CGFloat tableHeight = 1*HeightForTitle + MIN(MiniCells, _textArray.count)*HeightForCommonCell;
    self.tableViewHeight.constant = MIN([UIScreen mainScreen].bounds.size.height, tableHeight);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.tableView.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                         self.tableView.alpha = 1;
                     }
                     completion:^(BOOL finished){
//                         [self.tableView reloadData];
                     }];
}

- (void)dismss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        //        self.containerView.transform = CGAffineTransformScale(_containerView.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        self.tableView.alpha = 0;
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismss];
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

+ (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry {
    YYAlertTable *alertTable = [YYAlertTable instanceFromNib];
    return [alertTable showWithTitle:title textArry:textArry];
}

@end