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

@end


@protocol JMRenderableCell <NSObject>

@optional
/* 如果需要代理 */
@property (nonatomic, weak) id delegate;

@required
- (void)updateWithModel:(id<JMRenderableCellModel>)model
              indexPath:(NSIndexPath *)indexPath
              container:(UIView *)container;

/*
 用于cell高度固定或根据model方便的知道cell的高度,
 不指定的话使用UITableView+FDTemplateLayoutCell.h计算高度
 */
@optional
+ (CGFloat)heightForModel:(id<JMRenderableCellModel>)model
                indexPath:(NSIndexPath *)indexPath
                container:(UIView *)container;

@end


/**
 设置好数据源即可知道如何自动配置数据的UITableView
 */
@interface JMRenderableTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

//数据源，里面的model必须遵守GoodsDetailModel协议
@property (nonatomic, copy) NSArray<id<JMRenderableCellModel>> *dataArray;

/*
 使用前必须手动先注册，只需要传class即可，内部会自动判断是否有xib，如下：
 NSArray *cellClass = @[
     DemoCell.class,
     DemoCell2.class,
 ];
 [tableView regitsterCells:cellClass];
 */
- (void)regitsterCells:(NSArray<Class> *)cellClassArray;
- (void)reloadData:(NSArray<id<JMRenderableCellModel>> *)dataArray;

@end













