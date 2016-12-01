//
//  JMGoodsDetailContainerViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"

/** 重构版商品详情 入口VC*/
@interface JMGoodsDetailContainerViewController : UIViewController

#pragma mark - Public

@property (nonatomic, strong) NSString  *itemId;
@property (nonatomic, strong) NSString  *productType;
@property (nonatomic, strong) NSString  *currentItemId;
@property (nonatomic, strong) NSString  *currentProductType;

@property (nonatomic, strong) NSString  *sroucFrom;
@property (nonatomic, strong) NSString  *from; // 线下扫码需要的字段
@property (nonatomic, assign) BOOL      fromeDetail;
@property (nonatomic, assign) BOOL      ifPushTuanPageType;

@property (nonatomic, copy) NSString *pageParamID;
@property (nonatomic, strong) NSDictionary *dicDataAnalyze;

//@property (nonatomic, strong) MAProduct *product;
@property (nonatomic, assign) BOOL isNotNeedCancelRequestWhenDealloc;

#pragma mark -
@property (nonatomic, strong) JMGoodsDetailManager *goodsDetailManager;


/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;

/*
 我的足迹
 */
- (void)showBrowseHistoryButtonIfNeeded;


@end
