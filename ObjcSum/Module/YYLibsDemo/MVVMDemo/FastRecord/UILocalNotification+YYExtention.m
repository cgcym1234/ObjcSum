//
//  UILocalNotification+YYExtention.m
//  ObjcSum
//
//  Created by sihuan on 15/12/24.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UILocalNotification+YYExtention.h"

@implementation UILocalNotification (YYExtention)

+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *info = userInfo[key];
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

@end
