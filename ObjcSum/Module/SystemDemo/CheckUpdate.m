//
//  CheckUpdate.m
//  ObjcSum
//
//  Created by yangyuan on 2018/5/15.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "CheckUpdate.h"
#import "AFNetworking.h"

@implementation CheckUpdate

/*
 iOS 想要检查 App 当前版本是否为最新，一般的方案大概都是服务器自己提供一个接口来获取 App 最新版本是多少，然后再做出相应提示是否需要更新，但是接口需要手动维护，应用要审核，还得等审核通过以后才能更新版本号，其实苹果提供了一个 iTunes 接口，能够查到 App 在 AppStore 上的状态信息，既省事又准确，下面记录一下具体实现方法。
 */

/// 检查版本更新
- (void)checkVersion {
	NSString *url = @"http://itunes.apple.com/lookup?id=xxx";

	[[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
		//DLog(@"版本更新检查成功");
		NSArray *results = responseObject[@"results"];
		if (results && results.count > 0) {
			NSDictionary *response = results.firstObject;
			NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]; // 软件的当前版本
			NSString *lastestVersion = response[@"version"]; // AppStore 上软件的最新版本
			if (currentVersion && lastestVersion && ![self isLastestVersion:currentVersion compare:lastestVersion]) {
				// 给出提示是否前往 AppStore 更新
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到有版本更新，是否前往 AppStore 更新版本。" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
					NSString *trackViewUrl = response[@"trackViewUrl"]; // AppStore 上软件的地址
					if (trackViewUrl) {
						NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
						if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
							[[UIApplication sharedApplication] openURL:appStoreURL];
						}
					}
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
				//		[self.window.rootViewController presentViewController:alert animated:YES completion:nil];
			}
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		//	DLog(@"版本更新检查失败");
	}];
}


/// 判断是否最新版本号（大于或等于为最新）
- (BOOL)isLastestVersion:(NSString *)currentVersion compare:(NSString *)lastestVersion {
	if (currentVersion && lastestVersion) {
		// 拆分成数组
		NSMutableArray *currentItems = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
		NSMutableArray *lastestItems = [[lastestVersion componentsSeparatedByString:@"."] mutableCopy];
		// 如果数量不一样补0
		NSInteger currentCount = currentItems.count;
		NSInteger lastestCount = lastestItems.count;
		if (currentCount != lastestCount) {
			NSInteger count = labs(currentCount - lastestCount); // 取绝对值
			for (int i = 0; i < count; ++i) {
				if (currentCount > lastestCount) {
					[lastestItems addObject:@"0"];
				} else {
					[currentItems addObject:@"0"];
				}
			}
		}
		// 依次比较
		BOOL isLastest = YES;
		for (int i = 0; i < currentItems.count; ++i) {
			NSString *currentItem = currentItems[i];
			NSString *lastestItem = lastestItems[i];
			if (currentItem.integerValue != lastestItem.integerValue) {
				isLastest = currentItem.integerValue > lastestItem.integerValue;
				break;
			}
		}
		return isLastest;
	}
	return NO;
}

@end
