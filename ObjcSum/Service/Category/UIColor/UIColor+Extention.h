//
//  UIColor+Extention.h
//  MLLCustomer
//
//  Created by sihuan on 15/5/8.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extention)

#pragma mark - 将16进制颜色转换成UIColor
+ (UIColor *)colorWithHexString:(NSString *)hexString;

#pragma mark - UIColor 转换成 NSString
- (NSString *)stringFromColorSelf;


@end
