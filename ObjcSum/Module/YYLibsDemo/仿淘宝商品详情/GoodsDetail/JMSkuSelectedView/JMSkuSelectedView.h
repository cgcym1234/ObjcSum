//
//  JMSkuSelectedView.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSkuSelectedViewModel.h"

@class JMSkuSelectedView;

@protocol JMSkuSelectedViewDelegate <NSObject>

@optional
/* 联动选择到可以定位某个sku时调用, 并提供该sku数据*/
- (void)jmSkuSelectedView:(JMSkuSelectedView *)view didLocateSkuWithInfo:(SkuInfo *)skuInfo;

/* 点击关闭时调用*/
- (void)jmSkuSelectedViewDidPerformCloseAction:(JMSkuSelectedView *)view;

/* 点击确认时调用*/
- (void)jmSkuSelectedViewDidPerformConfirmAction:(JMSkuSelectedView *)view;

@end

/**< Sku弹窗 */
@interface JMSkuSelectedView : UIView<JMComponent>

@property (nonatomic, strong) JMSkuSelectedViewModel *model;
@property (nonatomic, weak) id<JMSkuSelectedViewDelegate> delegate;

- (void)reloadWithData:(id<JMComponentModel>)model;

- (void)showInWindowWithData:(JMSkuSelectedViewModel *)data;
- (void)dismiss;

@end
