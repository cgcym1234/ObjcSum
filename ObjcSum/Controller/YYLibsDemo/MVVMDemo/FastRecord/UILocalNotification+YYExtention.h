//
//  UILocalNotification+YYExtention.h
//  ObjcSum
//
//  Created by sihuan on 15/12/24.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (YYExtention)

#pragma mark - 取消本地通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key;

@end
