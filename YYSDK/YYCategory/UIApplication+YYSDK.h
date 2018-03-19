//
//  UIApplication+YYSDK.h
//  YYSDK
//
//  Created by yangyuan on 2018/3/5.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (YYSDK)

#pragma mark - 打电话
+ (void)makePhoneCall:(NSString *)phone;
+ (void)openSetting;
+ (void)openUrl:(NSString *)string;

@end
