//
//  AppInfo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/14.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "AppInfo.h"
#import "NSString+Extention.h"

#define AppConfigPlist            @"AppConfig"
#define KeyAppChannel             @"AppChannel"  //AppConfig.plist中 渠道的key

@implementation AppInfo

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AppInfo *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appChannel = AppStoreChannel;
        
        _beFirstLaunch = YES;   //是否为第一次启动标记，如果是第一次启动则不需要提示wifi联网信息
//        self.networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
//        [self networkMonitor];
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

@end
