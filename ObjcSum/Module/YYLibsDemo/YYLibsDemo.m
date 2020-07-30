//
//  YYLibsDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYLibsDemo.h"




@interface YYLibsDemo ()


@property (nonatomic, strong) NSString *test;

@end

@implementation YYLibsDemo


@dynamic test;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
                     
                     [[LibDemoInfo alloc] initWithTitle:@"MapNavigationDemo" desc:@"地图导航" controllerName:@"MapNavigationDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"PushPresentDemo" desc:@"Push或Present时监听" controllerName:@"PushPresentDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"YYGlobalTimerDemo" desc:@"全局定时器" controllerName:@"YYGlobalTimerDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"AutoLayoutDemo" desc:@"AutoLayout测试" controllerName:@"AutoLayoutDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"GoodsDetailContainer" desc:@"仿淘宝商品详情" controllerName:@"GoodsDetailContainer"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"PullRefreshDemo" desc:@"自定义下拉刷新" controllerName:@"PullRefreshDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYMessageViewController" desc:@"聊天界面demo" controllerName:@"YYMessageViewController"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"MVVMDemo" desc:@"随手记MVVM版" controllerName:@"MVVMDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYCacheTest" desc:@"YYCache性能测试" controllerName:@"YYCacheTest"],
                     
                     
                     [[LibDemoInfo alloc] initWithTitle:@"LoginDemo" desc:@"登录demo" controllerName:@"LoginDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYKeyValueStoreDemo" desc:@"KV存储库" controllerName:@"SqlliteDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYScrollSigmentDemo" desc:@"ScrollSigment滑动选择条" controllerName:@"YYScrollSigmentDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"一些Alert控件" desc:@"弹出输入,选择等控件" controllerName:@"YYAlertTextViewDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"EncryptionDemo" desc:@"加密相关" controllerName:@"EncryptionDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"CountdownDemo" desc:@"倒计时功能" controllerName:@"CountdownDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYComponentsDemo" desc:@"一些小控件" controllerName:@"YYComponentsDemo"],
                     ];
    
}



@end
