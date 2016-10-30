//
//  ApplicationInfo.m
//  MLLCustomer
//
//  Created by sihuan on 15/9/15.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "ApplicationInfo.h"

#import "MBProgressHUD.h"
#import "NSString+Extention.h"

#define MLLNetworkTipTime                 (2)
#define MLLNoNetworkTipWords              @"您的网络不是很顺畅哦!"
#define MLLConnectWifiTipWords            @"您已经连接wifi，"
#define MLLConnectWifiTip_Next_Words      @"将为您加载高清图"
#define MLLConnectMobileTipWords          @"您正在使用移动网络，"
#define MLLConnectMobile_Next_TipWords    @"已为您开始省流量模式"


#define AppConfigPlist            @"AppConfig"
#define KeyAppChannel             @"AppChannel"  //AppConfig.plist中 渠道的key


@interface ApplicationInfo ()

@property (strong, nonatomic) AFNetworkReachabilityManager *networkReachabilityManager;
@property (assign, nonatomic) AFNetworkReachabilityStatus currentStatus;

@end

@implementation ApplicationInfo

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ApplicationInfo *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ApplicationInfo alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appChannel = AppStoreChannel;
        
        _beFirstLaunch = YES;   //是否为第一次启动标记，如果是第一次启动则不需要提示wifi联网信息
        self.networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [self networkMonitor];
        _beShowImage = NO;
        
        
        NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
        
        self.appUUID = [NSString uniqueDeviceIdentifier];
        self.appProductName = dict[@"CFBundleExecutable"];
        self.appBundleIdentifier = dict[@"CFBundleIdentifier"];
        self.appName = dict[@"CFBundleName"];
        self.appVersion = dict[@"CFBundleShortVersionString"];
        self.appVersionBuild = dict[@"CFBundleVersion"];
        self.appPlatformName = dict[@"DTPlatformName"];
        self.appSDKName = dict[@"DTSDKName"];
        
        
        
        NSString *appConfigPath = [[NSBundle mainBundle] pathForResource:AppConfigPlist ofType:@"plist"];
        if (appConfigPath) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:appConfigPath];
            if (dict) {
                NSString *tempValue = dict[KeyAppChannel];
                
                _appChannel =  tempValue.length > 0 ? tempValue : AppStoreChannel;
            }
        }
    }
    return self;
}

- (void)dealloc {
    [self.networkReachabilityManager stopMonitoring];
}

#pragma mark - network

- (MLLNetworkReachabilityStatus)reachabilityStatus
{
    return self.networkReachabilityManager.networkReachabilityStatus;
}

- (BOOL)isReachable
{
    return self.networkReachabilityManager.isReachable;
}

- (BOOL)isReachableViaWiFi
{
    return self.networkReachabilityManager.isReachableViaWiFi;
}

- (BOOL)isReachableViaWWAN
{
    return self.networkReachabilityManager.isReachableViaWWAN;
}


/**
 *  网络监听
 */
- (void)networkMonitor
{
    __weak __typeof(self)wself = self;
    [self.networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(wself)sSelf = wself;
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                if (sSelf.currentStatus != status && sSelf.currentStatus != AFNetworkReachabilityStatusUnknown)
                {
                    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [sSelf showTipNoNetWorkWithWords:MLLNoNetworkTipWords detailwords:nil];
                        });
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_DISCONNECT_NOTIFICATION object:nil];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [sSelf showTipNoNetWorkWithWords:MLLConnectWifiTipWords detailwords:MLLConnectWifiTip_Next_Words];
                if (sSelf.currentStatus == AFNetworkReachabilityStatusNotReachable)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_RECONNECT_NOTIFICATION object:nil];
                }
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if (sSelf.currentStatus == AFNetworkReachabilityStatusNotReachable)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_RECONNECT_NOTIFICATION object:nil];
                }
                [sSelf showTipNoNetWorkWithWords:MLLConnectMobileTipWords detailwords:MLLConnectMobile_Next_TipWords];
                break;
            }
            default:
                break;
        }
        
        // 赋值
        sSelf.currentStatus = status;
    }];
    
    // 开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            [self showTipNoNetWorkWithWords:MLLNoNetworkTipWords detailwords:nil];
        }
    });
}

/**
 *  提示语问题
 */
- (void)showTipNoNetWorkWithWords:(NSString *)words detailwords:(NSString *)detailWord
{
    // 第一次启动不展示提示信息
    if (_beFirstLaunch)
    {
        _beFirstLaunch = NO;
        return;
    }
    MBProgressHUD *tip = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    tip.labelText = words;
    tip.detailsLabelText = detailWord;
    tip.detailsLabelFont = [UIFont systemFontOfSize:15];
    tip.labelFont = [UIFont systemFontOfSize:15];
    tip.mode = MBProgressHUDModeText;
    [tip hide:YES afterDelay:MLLNetworkTipTime];
}


@end
