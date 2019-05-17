//
//  AppInfo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/14.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "AppInfo.h"
#import "NSString+Extention.h"


#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

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


- (NSString *) macaddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

@end
