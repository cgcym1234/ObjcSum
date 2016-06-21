//
//  LocalNotificationDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/10/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "LocalNotificationDemo.h"

@interface LocalNotificationDemo ()

@end

@implementation LocalNotificationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 本地通知

- (void)registerLocalNotification {
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

#pragma mark - 第一步：注册本地通知：
- (void)setLocalNotificationAtDate:(NSDate *)date title:(NSString *)title text:(NSString *)text key:(NSString *)key value:(id)value {
    
    if ([date compare:[NSDate date]] != NSOrderedDescending) {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    NSDate *fireDate = date;
    
    // 设置触发通知的时间
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 设置重复的间隔,可以是天、周、月
    notification.repeatInterval = 0;
    
    //8.2之后可以设置标题
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) {
        notification.alertTitle = title;
    }
    // 通知内容
    notification.alertBody = text;
    
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知参数
    NSDictionary *userDict = @{key:value};
    notification.userInfo = userDict;
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - 第二步：处理通知，这个是在appdelegate中的代理 方法回调
// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知(前台)"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
//     在不需要再推送时，可以取消推送
    [LocalNotificationDemo cancelLocalNotificationWithKey:@"key"];
}

#pragma mark - 第三步：在需要的时候取消某个推送
// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;  
            }  
        }  
    }  
}

@end
