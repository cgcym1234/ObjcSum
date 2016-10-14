//
//  YYSimpleAlertTable.h
//  tttt
//
//  Created by sihuan on 15/12/23.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSimpleAlertTable;

typedef void (^YYSimpleAlertTableDidClickedBlock)(YYSimpleAlertTable *alertTable, NSInteger index);

@interface YYSimpleAlertTable : UITableView

//选择的内容
@property (nonatomic, strong) NSArray *textArry;

//自定义宽度 如果width <= 0 使用默认值
@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) YYSimpleAlertTableDidClickedBlock didClickedBlock;


+ (instancetype)showWithTextArry:(NSArray *)textArry;
- (void)showWithTextArry:(NSArray *)textArry;
- (void)show;

@end;