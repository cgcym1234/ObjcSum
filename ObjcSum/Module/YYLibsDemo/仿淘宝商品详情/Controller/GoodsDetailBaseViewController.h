//
//  GoodsDetailBaseViewController.h
//  MLLCustomer
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetail.h"

@interface GoodsDetailBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<GoodsDetailEventDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomContainer;

//数据源，里面的model必须遵守GoodsDetailModel协议
@property (nonatomic, strong) NSMutableArray<GoodsDetailModel> *dataArray;

- (void)reloadData;

@end
