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
                     [[LibDemoInfo alloc] initWithTitle:@"FoundationDemo" desc:@"基本数据结构测试" controllerName:@"FoundationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"LocalNotificationDemo" desc:@"本地通知" controllerName:@"LocalNotificationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"UISearchDemo" desc:@"搜索相关" controllerName:@"UISearchDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYAlertTextViewDemo" desc:@"alert输入框" controllerName:@"YYAlertTextViewDemo"],
                     
                     ];
}


@end
