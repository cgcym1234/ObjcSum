//
//  YYScrollSigment.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

//选中时候的颜色，包括指示条
#define ItemColorSelected                    [UIColor colorWithRed:39/255.0 green:167/255.0 blue:224/255.0 alpha:1]
#define ItemColorNormal                      [UIColor darkGrayColor]

@class YYScrollSigment;

//配置cell的协议,自定义item时候必须实现
@protocol YYScrollSigmentCellProtocol

@required
//配置cell
- (void)updateWithItem:(id)item atIndexPath:(NSIndexPath *)indexPath inView:(YYScrollSigment *)view;

/**
 *  选中和取消选中时的状态
 *
 *  @param isSelected 是否选中
 *  @param animated 是否带动画
 */
- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated;

@end


//回调block
typedef void (^YYScrollSigmentDidSelectedItemBlock)(YYScrollSigment *view, NSInteger idx);
//typedef void (^YYScrollSigmentDidScrollingBlock)(YYScrollSigment *view, NSInteger currentIndex);

@interface YYScrollSigment : UIView


//使用UICollectionView实现
@property (nonatomic, strong) UICollectionView *collectionView;

//存放数据源的数组，默认标题string
@property(nonatomic, copy)NSArray *dataArr;

//总数
@property (nonatomic, assign) NSInteger totalIndex;

//当前选中项，默认0
@property (nonatomic, assign) NSInteger currentIndex;

//设置是否按页滑动,默认否
@property (nonatomic, assign) BOOL pagingEnabled;

//默认itemSizeAuto=yes，就是CGRectGetWidth(self.bounds)/totalIndex的大小
@property (nonatomic, assign) BOOL itemSizeAuto;

//手动设置itemSize的大小，设置itemSizeAuto=no时，生效
@property (nonatomic, assign) CGFloat itemWith;

//条形指示条
@property (nonatomic, strong) UIView *indicatorView;
//条形指示条高度，默认4
@property (nonatomic, assign) CGFloat indicatorViewHeight;
//设置条形指示条是否显示,默认YES
@property(nonatomic, assign) BOOL indicatorViewEnable;

/**
 *  是否显示底部的一条线,以及线的颜色,默认显示,d8d8d8
 */
@property(nonatomic, assign) BOOL bottomLineEnable;
@property(nonatomic, strong) UIColor *bottomLineColor;


@property(nonatomic, copy)YYScrollSigmentDidSelectedItemBlock didSelectedItemBlock;
//@property(nonatomic, copy)YYScrollSigmentDidScrollingBlock didScrollingBlock;



- (instancetype)initWithDataArr:(NSArray *)dataArr;


- (instancetype)initWithDataArr:(NSArray *)imageNames
                          frame:(CGRect)frame;

@end
