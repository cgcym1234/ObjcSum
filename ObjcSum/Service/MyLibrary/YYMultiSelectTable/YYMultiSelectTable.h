//
//  YYMultiSelectTable.h
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMultiSelectModel.h"

@class YYMultiSelectTable;

typedef void (^YYMultiSelectTableDidClickedBlock)(YYMultiSelectTable *view, NSInteger buttonIndex);

@interface YYMultiSelectTable : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//标题
@property (nonatomic, copy) NSString *title;

//选择的内容 YYMultiSelectModel数组
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableSet *selectedIndexNumber;

@property (nonatomic, copy) YYMultiSelectTableDidClickedBlock didClickedBlock;

+ (instancetype)instanceFromNib;
+ (instancetype)showWithTitle:(NSString *)title dataArr:(NSArray *)dataArr;
- (void)showWithTitle:(NSString *)title dataArr:(NSArray *)dataArr;
- (void)show;


@end