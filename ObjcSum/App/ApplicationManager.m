//
//  ApplicationManager.m
//  MLLCustomer
//
//  Created by sihuan on 15/9/15.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "ApplicationManager.h"

#import "UncaughtExceptionHandler.h"
#import "Aspects.h"
//#import "MobClick.h"
//#import "UMessage.h"
//#import "UMTrack.h"
//
//#import "VersionChecker.h"
//#import "SocialMachine.h"


static NSDictionary *_launchOptions;

@interface ApplicationManager ()

@end

@implementation ApplicationManager

//在初始化中完成配置
+ (instancetype)configAppWithLaunchOptions:(NSDictionary *)launchOptions {
    _launchOptions = [launchOptions copy];
    return [self sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ApplicationManager *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ApplicationManager alloc] init];
        
    });
    return _sharedInstance;
}

//在初始化中完成配置
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // state initial
        [self updateApplicationState];
        
        // Http cache
        [self updateCacheSetting];
        
        // session ID
        [self readEscidFromLocal];
        [self updateSessionID];
        
        //app的一些信息，状态等初始化
        [ApplicationInfo sharedInstance];
        
//        //使用aspect做一些统一操作，目前是友盟页面统计
//        [self addAspectConfiguration];
        
        //修改所有UIWebView 请求时的UserAgent
        [self addUserAgentForWebView];
        
//        //统计功能
        [self addStatistic];
//
//        //推广效果分析功能
        [self addPromotionTracker];
//
//        //推送功能
        [self addRemoteNotification];
//
        //分享初始化
//        [SocialMachine registerForApp];
//
//        // 版本检测
//        [[VersionChecker shareVersionChecker] startVersionChecking];
        
        //异常
        InstallExceptionHandler();
  
        //3d Touch: Only for iOS 9.0+，请勿在小助手打开,--added by chesterlee
        //[self initThreeDimensionTouch];
    }
    return self;
}

#pragma mark - 初始化模块接口

/**
 *  初始化应用程序状态
 */
- (void)updateApplicationState
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //防止导航栏变黑
    [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
}

/**
 *  更新缓存设置
 */
- (void)updateCacheSetting
{
//    [NSURLCache setSharedURLCache:[[NSURLCache alloc]
//                                   initWithMemoryCapacity:(MemoryCapacity * 1024 * 1024)
//                                   diskCapacity:(DiskCapacity * 1024 * 1024)
//                                   diskPath:nil]];
}

/**
 *  读取escid
 */
- (void)readEscidFromLocal
{
//    [[MeileleIdentification shared] writeLocalStoredEscidValueToCookie];
}

/**
 *  更新最新的session ID
 */
- (void)updateSessionID
{
//    if (![[MeileleIdentification shared] existCookieOfEscId]) {
//        [[MeileleIdentification shared] repairEscId];
//    }
}

/**
 *  APNs的注册，目前集成友盟
 */
- (void)registAPNs
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *notificationSetting = [UIUserNotificationSettings
                                                           settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                           categories:nil];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:notificationSetting];
        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSetting];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
//        [UMessage registerForRemoteNotificationTypes:apn_type];
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


/**
 *  使用aspect做一些统一操作，目前是友盟页面统计
 */
- (void)addAspectConfiguration {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, BOOL animated){
        [self viewWillAppear:animated viewController:[aspectInfo instance]];
    }  error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, BOOL animated){
        [self viewWillDisappear:animated viewController:[aspectInfo instance]];
    }  error:NULL];
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)vc {
    //友盟统计，注意友盟限制最多100界面，否则会被加入黑名单
    if (vc.titleForUMStatistic) {
//        [MobClick beginLogPageView:vc.titleForUMStatistic];
    }
}

- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)vc {
    if (vc.titleForUMStatistic) {
//        [MobClick endLogPageView:vc.titleForUMStatistic];
    }
}

/**
 *  修改所有UIWebView 请求时的UserAgent
 */
- (void)addUserAgentForWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = [NSString stringWithFormat:@"%@ %@",userAgent, UserAgentInRequest];
    NSDictionary *infoAgentDic = @{ @"UserAgent":newAgent };
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}


/**
 *  统计功能
 */
- (void)addStatistic
{
    /**
     *  这里使用AppConfig中的配置信息，但是如果配置的是appstore时
     *  有个业务转换，需要改成App Store,因为友盟统计之前已经定好了的名字是App Store
     *  而im那边的用的是appstore
     */
    NSString *appChannel = [ApplicationInfo sharedInstance].appChannel;
    if ([[appChannel lowercaseString] isEqualToString:AppStoreChannel]) {
        appChannel = @"App Store";
    }
    
//    [MobClick startWithAppkey:AppKeyForUM reportPolicy:BATCH channelId:appChannel];
//    [MobClick setCrashReportEnabled:YES];
    
}

/**
 *  推广效果分析功能
 */
- (void)addPromotionTracker
{
//    [UMTrack startWithAppkey:AppKeyForUM];
}

/**
 *  推送功能
 */
- (void)addRemoteNotification
{
//    [UMessage startWithAppkey:AppKeyForUM launchOptions:_launchOptions];
//    [UMessage setAutoAlert:NO];
    
    [self registAPNs];
}

#pragma mark- 3DTouch moudule, just ICON
/**
 *  3D Touch with icon, it's useless in MllSalesAssistant project. --added by chesterlee,2015-10-22
 */
- (void)initThreeDimensionTouch
{
//    UIApplication *application = [UIApplication sharedApplication];
    
//    UIApplicationShortcutIcon *firstIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
//    UIApplicationShortcutIcon *secondIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
//    UIApplicationShortcutIcon *thirdIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
//    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"first"
//                                                                                      localizedTitle:@"主页"
//                                                                                   localizedSubtitle:nil
//                                                                                                icon:firstIcon
//                                                                                            userInfo:nil];
//    
//    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"second"
//                                                                                      localizedTitle:@"搜索"
//                                                                                   localizedSubtitle:@"搜索美乐乐商品"
//                                                                                                icon:secondIcon
//                                                                                            userInfo:nil];
//    
//    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"third"
//                                                                                      localizedTitle:@"收藏"
//                                                                                   localizedSubtitle:@"我的收藏商品"
//                                                                                                icon:thirdIcon
//                                                                                            userInfo:nil];
//    application.shortcutItems = @[item1,item2, item3];
}

// handle 3D Touch' callback
+ (void)handleTouchWithShortcutItem:(UIApplicationShortcutItem *)item withCompleteBlock:(void(^)(BOOL succeeded))completeBlock
{
//    NSLog(@"callbacks");
//    
//    //sample
//    if ([@"first" isEqualToString:item.type]) {
//        
//        // do something
//    }
}

@end
