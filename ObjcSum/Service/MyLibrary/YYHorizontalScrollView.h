//
//  YYHorizontalScrollView.h
//  ObjcSum
//
//  Created by sihuan on 16/6/3.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHorizontalScrollViewCell.h"

@class YYHorizontalScrollView;

//回调
typedef void (^YYHorizontalScrollViewDidSelectItemBlock)(YYHorizontalScrollView *view, NSInteger selectedIndex);
typedef void (^YYHorizontalScrollViewDidScrollBlock)(YYHorizontalScrollView *view, NSInteger currentPage);

@interface YYHorizontalScrollView : UIView

@property(nonatomic, copy) YYHorizontalScrollViewDidSelectItemBlock didSelectItemBlock;
@property(nonatomic, copy) YYHorizontalScrollViewDidScrollBlock didScrollingBlock;

//存放数据源的数组
@property(nonatomic, copy) NSArray *dataArray;
//总页数
@property (nonatomic, assign, readonly) NSInteger totalPages;
//当前显示页
@property (nonatomic, assign) NSInteger currentPage;

//Item 大小,设置CGSizeZero表示和YYHorizontalScrollView同样大小
@property (nonatomic, assign) CGSize itemSize;
//设置是否按页滑动,默认yes
@property (nonatomic, assign) BOOL pagingEnabled;
//设置无限循环滑动，默认NO
@property (nonatomic, assign) BOOL infiniteScroll;
//设置底部圆点指示条是否显示,默认显示
@property(nonatomic, assign) BOOL pageControlShow;
//自动滚动的间隔，默认0秒。不自动滚动
@property (nonatomic, assign) NSInteger autoScrollInterval;

//必须注册一个实现YYHorizontalScrollViewCell协议的类
- (void)registerClass:(Class<YYHorizontalScrollViewCell>)cellClass;

//设置数据源后需要调用reloadData才会更新
- (void)reloadData;

@end
















