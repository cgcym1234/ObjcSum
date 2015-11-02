//
//  UIViewController+UMStatistic.h
//  MLLCustomer
//
//  Created by sihuan on 15/6/23.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMStatisticDefine.h"

#pragma mark - 友盟页面和事件统计
/**
 *  依赖 pod 'UMengAnalytics-NO-IDFA'
 */

@interface UIViewController (UMStatistic)

//用于友盟统计页面停留时长
@property (nonatomic, copy) NSString *titleForUMStatistic;

//用于友盟统计自定义事件
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number;

@end
