//
//  NSString+TransformToDisplay.h
//  MallData
//
//  Created by Lei Wu on 14-6-30.
//  Copyright (c) 2014年 jumei.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TransformToDisplay)
/**
 *  @brief 价格格式化显示 ¥xxx
 *
 *  @return ¥xxx
 */
- (NSString *)transformToMoneyDisplayFormat;
/**
 *  @brief 价格格式化显示 不带¥
 *
 *  @return xxx
 */
- (NSString *)transformToMoneyFormat;
/**
 *  @brief 价格格式化显示 ¥xxx 保留两位小数
 *
 *  @param money float 价格
 *
 *  @return ¥xxx.xx
 */
+ (NSString *)transformToMoneyDisplayFormatFromFloatValue:(float)money;
/**
 *  @brief 价格格式化显示 xxx 保留两位小数 不带¥
 *
 *  @param money float 价格
 *
 *  @return xxx.xx
 */
+ (NSString *)transformToMoneyFormatFromFloatValue:(float)money;


/**
 *	@brief	产品原价处理规则：接口返回为空或者-1时候不显示，其他时候都显示为¥abc...
 */
- (NSString *)origPriceDisplay;


/**
 *	@brief	产品折扣处理规则：接口返回为空或者-1时候不显示，其他时候都显示为abc...
 */
- (NSString *)discountDisplay;

/**
 *	@brief	产品原价，简单处理，不带¥
 */
- (NSString *)origPriceDisplayWithoutMoney;

/**
 *  @brief 对传参的字符串做非空判断 增加 折
 *
 *  @return xxx折
 */
- (NSString *)discountDisplayText;
/**
 *  @brief 对传参的字符串做非空判断 增加 ¥
 *
 *  @return ¥xxx
 */
- (NSString *)priceDisplayText;

@end
