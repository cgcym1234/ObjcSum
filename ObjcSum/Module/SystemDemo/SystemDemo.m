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

#pragma mark -  iOS 收到内存警告提醒处理
/*
 iOS 收到内存警告提醒处理 http://www.jianshu.com/p/a352fe08cae0
 */
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
                     [[LibDemoInfo alloc] initWithTitle:@"AuthenticationDemo" desc:@"指纹解锁" controllerName:@"AuthenticationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"TableViewDemo" desc:@"TableView相关" controllerName:@"TableViewDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"UIButtonDemo" desc:@"UIButtonDemo相关" controllerName:@"UIButtonDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"RuntimeDemo" desc:@"RunTime相关" controllerName:@"RuntimeDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"GestureDemo" desc:@"手势处理相关" controllerName:@"GestureDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"ThreadDemo" desc:@"多线程相关" controllerName:@"ThreadDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"WebViewDemo" desc:@"js和oc相互调用demo" controllerName:@"WebViewDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"ObjectiveCDemo" desc:@"Objective-C相关demo" controllerName:@"ObjectiveCDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"FoundationDemo" desc:@"基本数据结构测试" controllerName:@"FoundationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"LocalNotificationDemo" desc:@"本地通知" controllerName:@"LocalNotificationDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"UISearchDemo" desc:@"搜索相关" controllerName:@"UISearchDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"YYAlertTextViewDemo" desc:@"alert输入框" controllerName:@"YYAlertTextViewDemo"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"TestViewController" desc:@"一些测试" controllerName:@"TestViewController"],
                     
                     [[LibDemoInfo alloc] initWithTitle:@"UIDemosController" desc:@"常用系统控件篇" controllerName:@"UIDemosController"],
                     
                     ];
}

- (void)exitApplication {
    //直接退，看起来好像是 crash 所以做个动画
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        //退出代码
        exit(0);
    }
}
@end
