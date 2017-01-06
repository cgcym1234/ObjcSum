//
//  JMSkuSelectedView.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSkuSelectedViewModel.h"

typedef NS_ENUM(NSUInteger, JMSkuSelectedViewAction) {
    JMSkuSelectedViewActionClose, /* 点击关闭时*/
    JMSkuSelectedViewActionConfirm, /* 点击确认时*/
    JMSkuSelectedViewActionUsage, /* 点击尺码助手时*/
};

@class JMSkuSelectedView;

@protocol JMSkuSelectedViewDelegate <NSObject>

@optional
/* 联动选择到可以定位某个sku时调用, 并提供该sku数据*/
- (void)jmSkuSelectedView:(JMSkuSelectedView *)view didLocateSkuWithInfo:(SkuInfo *)skuInfo;

/* 点击关闭，确认等操作时调用*/
- (void)jmSkuSelectedView:(JMSkuSelectedView *)view didPerformAction:(JMSkuSelectedViewAction)action;


@end

/**< Sku弹窗 */
@interface JMSkuSelectedView : UIView<JMComponent>

@property (nonatomic, strong) JMSkuSelectedViewModel *model;
@property (nonatomic, weak) id<JMSkuSelectedViewDelegate> delegate;

- (void)reloadWithData:(id<JMComponentModel>)model;

- (void)showInWindowWithData:(JMSkuSelectedViewModel *)data;
- (void)dismiss;

@end
