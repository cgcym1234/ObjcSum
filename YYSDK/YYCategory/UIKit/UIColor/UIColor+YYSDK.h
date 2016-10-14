//
//  UIColor+YYSDK.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YYSDK)

/**< 随机色 */
+ (instancetype)random;

/**< 将16进制 @"0x666666" 转换成UIColor */
+ (instancetype)colorWithHexString:(NSString *)hexString;

/**< UIColor 转换成 @"0x666666" */
- (NSString *)hexString;

@end
