//
//  GoodsDetailNomalViewController.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "JMRenderableTableView.h"
#import "GoodsDetail.h"

//普通商品详情
@interface GoodsDetailNomalViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, weak) id<GoodsDetailEventDelegate> delegate;
@property (nonatomic, strong, readonly) JMRenderableTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomContainer;

//数据源，里面的model必须遵守JMRenderableCellModel协议
@property (nonatomic, strong) NSMutableArray<JMRenderableCellModel> *dataArray;

@end
