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
                   [[LibDemoInfo alloc] initWithTitle:@"YYMessageViewController" desc:@"聊天界面demo" controllerName:@"YYMessageViewController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"MVVMDemo" desc:@"随手记MVVM版" controllerName:@"MVVMDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYCacheTest" desc:@"YYCache性能测试" controllerName:@"YYCacheTest"],
                   
                   
                   [[LibDemoInfo alloc] initWithTitle:@"LoginDemo" desc:@"登录demo" controllerName:@"LoginDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYKeyValueStoreDemo" desc:@"KV存储库" controllerName:@"SqlliteDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"YYScrollSigmentDemo" desc:@"ScrollSigment滑动选择条" controllerName:@"YYScrollSigmentDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"一些Alert控件" desc:@"弹出输入,选择等控件" controllerName:@"YYAlertTextViewDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"EncryptionDemo" desc:@"加密相关" controllerName:@"EncryptionDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"CountdownDemo" desc:@"倒计时功能" controllerName:@"CountdownDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"聊天界面demo" desc:@"聊天界面demo" controllerName:@"ChatMessagesDemo"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"iCarouselDemo" desc:@"iCarousel旋转切换效果控件" controllerName:@"iCarouselDemo"],
                   ];
}


@end
