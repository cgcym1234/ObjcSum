//
//  ApplicationInfo.h
//  MLLCustomer
//
//  Created by sihuan on 15/9/15.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"


#define NETWORK_RECONNECT_NOTIFICATION @"network_reconnected" //网络恢复通知
#define NETWORK_DISCONNECT_NOTIFICATION @"network_disconnected" //网络断开通知

typedef NS_ENUM(NSUInteger, MLLNetworkReachabilityStatus) {
    MLLNetworkReachabilityStatusUnknown = AFNetworkReachabilityStatusUnknown,
    MLLNetworkReachabilityStatusNotReachable = AFNetworkReachabilityStatusNotReachable,
    MLLNetworkReachabilityStatusReachableViaWWAN = AFNetworkReachabilityStatusReachableViaWWAN,
    MLLNetworkReachabilityStatusReachableViaWiFi = AFNetworkReachabilityStatusReachableViaWiFi
};

#define AppStoreChannel        @"Appstore"   // Appstore渠道，默认值

#pragma mark - app的一些信息，状态

@interface ApplicationInfo : NSObject

//渠道，以AppConfig.plist中配置为准，如果没配置，使用AppStoreChannel
@property (nonatomic, copy) NSString *appChannel;

//是否为第一次启动标记，如果是第一次启动则不需要提示wifi联网信息
@property (nonatomic, assign) BOOL beFirstLaunch;

//全局是否正在展示需要横屏旋转的图像（注意需要出入重置）
@property (nonatomic, assign) BOOL beShowImage;


//hash 后的UUID
@property (nonatomic, strong) NSString *appUUID;

//工程名字
@property (nonatomic, strong) NSString *appProductName;

//"com.huan.xxx"
@property (nonatomic, strong) NSString *appBundleIdentifier;

//自定义的名字
@property (nonatomic, strong) NSString *appName;

//1.0
@property (nonatomic, strong) NSString *appVersion;

//1
@property (nonatomic, strong) NSString *appVersionBuild;

//iphonesimulator
@property (nonatomic, strong) NSString *appPlatformName;

//iphonesimulator8.3
@property (nonatomic, strong) NSString *appSDKName;

#pragma mark -下面的属性不要注册KVO.
//网络是否连接。
@property (readonly, nonatomic, getter = isReachable) BOOL reachable;

//通过移动数据连接网络.
@property (readonly, nonatomic, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

//通过wifi数据连接网络
@property (readonly, nonatomic, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (instancetype)sharedInstance;

@end
