//
//  YYSegmentedView.h
//  ObjcSum
//
//  Created by yangyuan on 2016/11/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSegmentedView;

typedef void (^YYSegmentedViewIndexChangedBlock)(YYSegmentedView *view, NSInteger toIndex, NSInteger prevIndex);

@interface YYSegmentedView : UIScrollView

//存放数据源的数组，默认标题string
@property(nonatomic, copy)NSArray<NSString *> *titles;

//总数
@property (nonatomic, assign, readonly) NSInteger totalIndex;

//当前选中项，默认0
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, assign, readonly) NSInteger prevIndex;

@property (nonatomic, copy) YYSegmentedViewIndexChangedBlock indexChangedBlock;

//fixedItemWith > 0 则使用该宽度，否则根据文字长度自动计算
@property (nonatomic, assign) CGFloat fixedItemWidth;

//文字的左右间距，默认10
@property (nonatomic, assign) CGFloat paddingLeftRight;

//default [UIFont systemFontOfSize:14]
@property(nonatomic, strong) UIFont *titleFont;
//default 0x333333
@property(nonatomic, strong) UIColor *titleColorNomal;
//default 0xF33873
@property(nonatomic, strong) UIColor *titleColorSelected;

/**
 *  是否显示底部选中状态条形指示条,以及高度,默认YES,高度2，颜色同选中文字颜色
 */
@property(nonatomic, assign) BOOL indicatorViewEnable;
@property (nonatomic, assign) CGFloat indicatorViewHeight;

/**
 *  是否显示底部的一条线,以及线的颜色,默认NO,颜色d8d8d8
 */
@property(nonatomic, assign) BOOL bottomLineEnable;
@property(nonatomic, strong) UIColor *bottomLineColor;

- (void)setTitles:(NSArray<NSString *> *)titles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end
