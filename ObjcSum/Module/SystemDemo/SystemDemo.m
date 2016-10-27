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
