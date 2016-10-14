//
//  YYSegmentedControl.h
//  MLLSalesAssistant
//
//  Created by sihuan on 16/3/16.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - YYSegmentedControlItem

#define ItemColorSelected                    [UIColor colorWithRed:0.059 green:0.694 blue:0.729 alpha:1.000]
#define ItemColorNormal                      [UIColor colorWithWhite:0.400 alpha:1.000]

@class YYSegmentedControl;
//配置cell的协议,自定义item时候必须实现
@protocol YYSegmentedControlItem <NSObject>

@required

/**
 *  配置cell方法
 */
- (void)renderWithItem:(id)item atIndex:(NSInteger)index inSegmentControl:(YYSegmentedControl *)segmenteControl;
/**
 *  选中和取消选中时的状态
 */
- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated;

@end

#pragma mark - YYSegmentedControl

@protocol YYSegmentedControlDelegate <NSObject>

- (void)yySegmentedControl:(YYSegmentedControl *)segmenteControl didSelectItemAtIndex:(NSInteger)index;

@end

@interface YYSegmentedControl : UIView

@property (nonatomic, weak) id<YYSegmentedControlDelegate> delegate;

//存放数据源的数组，默认标题string
@property(nonatomic, copy) NSArray *dataArray;

//总数
@property (nonatomic, assign) NSInteger totalNum;

//当前选中项，默认0
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  是否显示底部的一条线,以及线的颜色,默认显示,d8d8d8
 */
@property(nonatomic, assign) BOOL bottomLineEnable;
@property(nonatomic, strong) UIColor *bottomLineColor;

//条形指示条高度，默认2
@property (nonatomic, assign) CGFloat indicatorViewHeight;
//设置条形指示条是否显示,默认YES
@property(nonatomic, assign) BOOL indicatorViewEnable;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArr;
- (void)reloadData;

@end






















