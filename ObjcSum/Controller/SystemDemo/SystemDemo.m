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
                     [[LibDemoInfo alloc] initWithTitle:@"RuntimeDemo" desc:@"RunTime相关" controllerName:@"RuntimeDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"GestureDemo" desc:@"手势处理相关" controllerName:@"GestureDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"ThreadDemo" desc:@"多线程相关" controllerName:@"ThreadDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"WebViewDemo" desc:@"js和oc相互调用demo" controllerName:@"WebViewDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"ObjectiveCDemo" desc:@"Objective-C特性测试" controllerName:@"ObjectiveCDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"FoundationDemo" desc:@"基本数据结构测试" controllerName:@"FoundationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"LocalNotificationDemo" desc:@"本地通知" controllerName:@"LocalNotificationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"UISearchDemo" desc:@"搜索相关" controllerName:@"UISearchDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYAlertTextViewDemo" desc:@"alert输入框" controllerName:@"YYAlertTextViewDemo"],
                     
                     ];
}


@end
