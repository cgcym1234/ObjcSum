//
//  NSDate+Extension.h
//  MLLCustomer
//
//  Created by sihuan on 15/5/11.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

#pragma mark - date转换成string
/**日期进行下面4种情况的转换
 *  今天：  19：00
 *  昨天：  昨天 19：00
 *  本周：  周二 19：00
 *  其他：  2014年4月3日 19：00
 */
- (NSString *)dateToVisbleStr;
@end
