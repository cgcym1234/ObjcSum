//
//  YYAlertTable.h
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYAlertTable;

typedef void (^YYAlertTableDidClickedBlock)(YYAlertTable *alertTable, NSInteger index);

@interface YYAlertTable : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//标题
@property (nonatomic, copy) NSString *title;

//选择的内容
@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, copy) YYAlertTableDidClickedBlock didClickedBlock;

+ (instancetype)instanceFromNib;
+ (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry;
- (instancetype)showWithTitle:(NSString *)title textArry:(NSArray *)textArry;
- (instancetype)show;


@end