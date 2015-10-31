//
//  YYLibsDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYLibsDemo.h"

@interface YYLibsDemo ()

@end

@implementation YYLibsDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[
                   [[LibDemoInfo alloc] initWithTitle:@"YYAlertGridViewDemo" desc:@"Alert表格选择" controllerName:@"YYAlertGridViewDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYAlertTableDemo" desc:@"alert选择" controllerName:@"YYAlertTableDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYAlertTextViewDemo" desc:@"alert输入框" controllerName:@"YYAlertTextViewDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"EncryptionDemo" desc:@"加密相关" controllerName:@"EncryptionDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"CountdownDemo" desc:@"倒计时功能" controllerName:@"CountdownDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"聊天界面demo" desc:@"聊天界面demo" controllerName:@"ChatMessagesDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"iCarouselDemo" desc:@"iCarousel旋转切换效果控件" controllerName:@"iCarouselDemo"],
                   ];
}


@end
