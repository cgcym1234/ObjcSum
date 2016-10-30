//
//  ApplicationManager.h
//  MLLCustomer
//
//  Created by sihuan on 15/9/15.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "ApplicationInfo.h"
#import "UIViewController+UMStatistic.h"
#import <UIKit/UIKit.h>

/**
 *  网络请求时在UserAgent中加入这个值，用来控制是否显示加载Web界面的header和footer
 *  目前有in_app_not_footer，in_app_not_header 2个值，空格隔开
 */
static NSString* const UserAgentInRequest = @"in_app_not_footer in_app_not_header";

/**
 *  友盟统计，推送的AppKey
 */
static NSString* const AppKeyForUM = @"5608d2fee0f55ae7bd003fc5";


#pragma mark - 全局的一些配置，状态，业务等

@interface ApplicationManager : NSObject

/**
 *  配置app
 */
+ (instancetype)configAppWithLaunchOptions:(NSDictionary *)launchOptions;

+ (instancetype)sharedInstance;

//handle 3D Touch
//+ (void)handleTouchWithShortcutItem:(UIApplicationShortcutItem *)item withCompleteBlock:(void(^)(BOOL succeeded))completeBlock;



















@end
