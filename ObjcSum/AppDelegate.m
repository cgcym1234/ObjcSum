//
//  AppDelegate.m
//  BackGroundTest
//
//  Created by 邓杰豪 on 15/11/4.
//  Copyright © 2015年 邓杰豪. All rights reserved.
//

#import "AppDelegate.h"

#import "ProccessHelper.h"

@interface AppDelegate ()
{
    NSMutableArray *systemprocessArray;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //延迟启动图显示时间,2秒
    sleep(2);
    systemprocessArray = [NSMutableArray arrayWithObjects:
                           @"kernel_task",
                           @"launchd",
                           @"UserEventAgent",
                           @"wifid",
                           @"syslogd",
                           @"powerd",
                           @"lockdownd",
                           @"mediaserverd",
                           @"mediaremoted",
                           @"mDNSResponder",
                           @"locationd",
                           @"imagent",
                           @"iapd",
                           @"fseventsd",
                           @"fairplayd.N81",
                           @"configd",
                           @"apsd",
                           @"aggregated",
                           @"SpringBoard",
                           @"CommCenterClassi",
                           @"BTServer",
                           @"notifyd",
                           @"MobilePhone",
                           @"ptpd",
                           @"afcd",
                           @"notification_pro",
                           @"notification_pro",
                           @"syslog_relay",
                           @"notification_pro",
                           @"springboardservi",
                           @"atc",
                           @"sandboxd",
                           @"networkd",
                           @"lsd",
                           @"securityd",
                           @"lockbot",
                           @"installd",
                           @"debugserver",
                           @"amfid",
                           @"AppleIDAuthAgent",
                           @"BootLaunch",
                           @"MobileMail",
                           @"BlueTool",nil];
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

#pragma mark -
#pragma mark - User Method

- (void) postMsg
{
    //上传到服务器
    NSURL *url = [self getURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error = nil;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

    if (error) {
        NSLog(@"error:%@", [error localizedDescription]);
    }

    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@>>>>>>>%@",str,url);
}

- (NSURL *) getURL
{
    UIDevice *device = [UIDevice currentDevice];

    NSString* uuid = @"TESTUUID";
    NSString* manufacturer = @"apple";
    NSString* model = [device model];
    NSString* mobile = [device systemVersion];

    NSString *strUrl = [NSString stringWithFormat:@"%@>%@>%@>%@",uuid,manufacturer,model,mobile];

    NSString *msg = [NSString stringWithFormat:@"Msg:%@  Time:%@", [self processMsg], [self getTime]];
    CFShow((__bridge CFTypeRef)(msg));

//    /  省略部分代码  /

    NSString *urlStr = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];

    return url;
}

- (BOOL) checkSystemProccess:(NSString *) proName
{
    if ([systemprocessArray containsObject:proName]) {
        return YES;
    }
    return NO;
}

- (BOOL) checkFirst:(NSString *) string
{
    NSString *str = [string substringToIndex:1];
    NSRange r = [@"ABCDEFGHIJKLMNOPQRSTUVWXWZ" rangeOfString:str];

    if (r.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *) processMsg
{
    NSArray *proMsg = [ProccessHelper runningProcesses];

    if (proMsg == nil) {
        return nil;
    }

    NSMutableArray *proState = [NSMutableArray array];
    for (NSDictionary *dic in proMsg) {

        NSString *proName = [dic objectForKey:@"ProcessName"];
        if (![self checkSystemProccess:proName] && [self checkFirst:proName]) {
            NSString *proID = [dic objectForKey:@"ProcessID"];
            NSString *proStartTime = [dic objectForKey:@"startTime"];

            if ([[dic objectForKey:@"status"] isEqualToString:@"18432"]) {
                NSString *msg = [NSString stringWithFormat:@"ProcessName:%@ - ProcessID:%@ - StartTime:%@ Running:YES", proName, proID, proStartTime];
                [proState addObject:msg];
            } else {
                NSString *msg = [NSString stringWithFormat:@"ProcessName:%@ - ProcessID:%@ - StartTime:%@ Running:NO", proName, proID, proStartTime];
                [proState addObject:msg];
            }
        }
    }

    NSString *msg = [proState componentsJoinedByString:@"______"];
    return msg;
}

// 获取时间
- (NSString *) getTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    formatter.locale = [NSLocale currentLocale];

    NSDate *date = [NSDate date];

    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];

    NSString *time = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", (long)year, month, day, hour, min, sec];

    return time;
}

@end
