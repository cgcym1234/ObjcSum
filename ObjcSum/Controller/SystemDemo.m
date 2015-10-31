//
//  SystemDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/10/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "SystemDemo.h"

@interface SystemDemo ()

@end

@implementation SystemDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
                     [[LibDemoInfo alloc] initWithTitle:@"LocalNotificationDemo" desc:@"本地通知" controllerName:@"LocalNotificationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYAlertTableDemo" desc:@"alert选择" controllerName:@"YYAlertTableDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYAlertTextViewDemo" desc:@"alert输入框" controllerName:@"YYAlertTextViewDemo"],
                     
                     ];
}


@end
