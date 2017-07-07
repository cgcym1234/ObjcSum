//
//  YYActionSheet.h
//  ObjcSum
//
//  Created by yangyuan on 2017/6/7.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYActionSheet, YYActionSheetItem;

typedef void (^YYActionSheetDidClickedBlock)(YYActionSheet *actionSheet, NSInteger index);

@interface YYActionSheet : UIView

@property (strong, nonatomic) UITableView *tableView;

//标题
@property (nonatomic, copy) NSString *title;

//选择的内容
@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, copy) YYActionSheetDidClickedBlock didClickedBlock;


+ (instancetype)showWithTitle:(NSString *)title texts:(NSArray *)texts action:(YYActionSheetDidClickedBlock)action;
+ (instancetype)showWithTitle:(NSString *)title texts:(NSArray *)texts destructiveLast:(BOOL)destructive action:(YYActionSheetDidClickedBlock)action;
+ (instancetype)showWithTitle:(NSString *)title items:(NSArray<YYActionSheetItem *> *)items action:(YYActionSheetDidClickedBlock)action;

- (instancetype)show;




@end
