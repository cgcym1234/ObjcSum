//
//  AppDelegate.m
//  BackGroundTest
//
//  Created by 邓杰豪 on 15/11/4.
//  Copyright © 2015年 邓杰豪. All rights reserved.
//

#import "AppDelegate.h"
#import <JSPatch/JSPatch.h>

@interface AppDelegate ()
{
    NSMutableArray *systemprocessArray;
}

@end

@implementation AppDelegate

/**
 *  解决iOS 键盘初始化的过程有延迟问题
 http://stackoverflow.com/a/9850093
 因为某种原因，当app以调试模式第一次在机上运行的时候就会出现这个情况。在release模式下不会有延迟。
 http://stackoverflow.com/a/20436797
 对于每次运行都出现延迟，下面一段代码可能有用：
 */
- (void)fixProblemKeyboardInitDelay {
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self fixProblemKeyboardInitDelay];
    
    static NSString *AppKeyJSPatch = @"32d4c3a5ffdfb78f";
    [JSPatch startWithAppKey:AppKeyJSPatch];
    [JSPatch sync];
    
    // Override point for customization after application launch.
    //延迟启动图显示时间,2秒
//    sleep(1);
//    systemprocessArray = [NSMutableArray arrayWithObjects:
//                           @"kernel_task",
//                           @"launchd",
//                           @"UserEventAgent",
//                           @"wifid",
//                           @"syslogd",
//                           @"powerd",
//                           @"lockdownd",
//                           @"mediaserverd",
//                           @"mediaremoted",
//                           @"mDNSResponder",
//                           @"locationd",
//                           @"imagent",
//                           @"iapd",
//                           @"fseventsd",
//                           @"fairplayd.N81",
//                           @"configd",
//                           @"apsd",
//                           @"aggregated",
//                           @"SpringBoard",
//                           @"CommCenterClassi",
//                           @"BTServer",
//                           @"notifyd",
//                           @"MobilePhone",
//                           @"ptpd",
//                           @"afcd",
//                           @"notification_pro",
//                           @"notification_pro",
//                           @"syslog_relay",
//                           @"notification_pro",
//                           @"springboardservi",
//                           @"atc",
//                           @"sandboxd",
//                           @"networkd",
//                           @"lsd",
//                           @"securityd",
//                           @"lockbot",
//                           @"installd",
//                           @"debugserver",
//                           @"amfid",
//                           @"AppleIDAuthAgent",
//                           @"BootLaunch",
//                           @"MobileMail",
//                           @"BlueTool",nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    #pragma mark - 无限后台运行和监听进程
//    while (1) {
//        sleep(5);
//        [self postMsg];
//    }

//    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
//        NSLog(@"KeepAlive");
//    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
