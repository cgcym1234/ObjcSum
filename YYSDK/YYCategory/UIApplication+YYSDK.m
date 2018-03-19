//
//  UIApplication+YYSDK.m
//  YYSDK
//
//  Created by yangyuan on 2018/3/5.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "UIApplication+YYSDK.h"

@implementation UIApplication (YYSDK)

#pragma mark - 打电话
+ (void)makePhoneCall:(NSString *)phone {
	[self openUrl:[NSString stringWithFormat:@"tel:%@", phone]];
}

+ (void)openSetting {
	[self openUrl:[NSString stringWithFormat:@"prefs:root=%@", @""]];
}

+ (void)openUrl:(NSString *)string {
	NSURL *url = [NSURL URLWithString:string];
	if (!url || ![[UIApplication sharedApplication] canOpenURL:url]) {
		return;
	}
	
	if (@available(iOS 10.0,*)) {
		[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
			
		}];
	} else {
		[[UIApplication sharedApplication] openURL:url];
	}
	
}

@end
