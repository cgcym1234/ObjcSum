//
//  JMRenderableTableView.h
//  JuMei
//
//  Created by yangyuan on 2016/9/29.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMRenderableCellModel <NSObject>

@required
@property (nonatomic, strong) Class cellClass;

/*
 用于cell高度固定或根据model方便的知道cell的高度,
 不指定的话使用UITableView+FDTemplateLayoutCell.h计算高度
 */
@optional
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end


@protocol JMRenderableCell <NSObject>

@optional
/* 如果需要代理 */
@property (nonatomic, weak) id delegate;

@required
- (void)updateWithCellModel:(id)model indexPath:(NSIndexPath *)indexPath containerView:(UIView *)view;

@end


/**
 设置好数据源即可知道如何自动配置数据的UITableView
 */
@interface JMRenderableTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

//数据源，里面的model必须遵守GoodsDetailModel协议
@property (nonatomic, strong) NSMutableArray<JMRenderableCellModel> *dataArray;


@end













