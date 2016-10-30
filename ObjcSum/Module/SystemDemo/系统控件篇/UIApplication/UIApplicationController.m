//
//  UIApplicationController.m
//  UI控件
//
//  Created by michael chen on 14-9-26.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIApplicationController.h"

@interface UIApplicationController ()

@end

@implementation UIApplicationController

#pragma mark - UIApplication介绍


#pragma mark - 1.简单介绍
/**
 *  一、UIApplication
 1.简单介绍
 （1）UIApplication对象是应用程序的象征，一个UIApplication对象就代表一个应用程序。
 
 （2）每一个应用都有自己的UIApplication对象，而且是单例的，如果试图在程序中新建一个UIApplication对象，那么将报错提示。
 
 （3）通过[UIApplication sharedApplication]可以获得这个单例对象
 
 （4） 一个iOS程序启动后创建的第一个对象就是UIApplication对象，且只有一个（通过代码获取两个UIApplication对象，打印地址可以看出地址是相同的）。
 
 （5）利用UIApplication对象，能进行一些应用级别的操作
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    #pragma mark - 置应用程序图标右上角的红色提醒数字,菊花转圈
    //1）设置应用程序图标右上角的红色提醒数字（如QQ消息的时候，图标上面会显示1，2，3条新信息等。）
    //通过sharedApplication获取该程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 12;
    
    //2)设置指示器的联网动画,菊花转圈
    app.networkActivityIndicatorVisible = YES;
    
    #pragma mark - 3）设置状态栏的两种方式
    /*
     3）管理状态栏
     
     从iOS7开始，系统提供了2种管理状态栏的方式
     
     1.通过UIViewController管理（每一个UIViewController都可以拥有自己不同的状态栏）.
     
     在iOS7中，默认情况下，状态栏都是由UIViewController管理的，UIViewController实现下列方法就可以轻松管理状态栏的可见性和样式
     
     状态栏的样式　　   - (UIStatusBarStyle)preferredStatusBarStyle;
     
     状态栏的可见性　　-(BOOL)prefersStatusBarHidden;
     
     2.通过UIApplication管理（一个应用程序的状态栏都由它统一管理）
     
     如果想利用UIApplication来管理状态栏，首先得修改Info.plist的设置
     Info.plist中增加 Status bar is initially hidden一行,选择为 YES,
     
     还需增加 View controller-based status bar appearance 一行,选择为 NO。
     
     UIApplication来进行管理有额外的好处，可以提供动画效果。
     */
    
    //app.statusBarStyle=UIStatusBarStyleDefault;//默认（黑色）
    //设置为白色+动画效果
    [app setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //设置状态栏是否隐藏
    app.statusBarHidden=YES;
    //设置状态栏是否隐藏+动画效果
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    #pragma mark 动态控制
    [self setNeedsStatusBarAppearanceUpdate];
    
    #pragma mark - 4）openURL:方法
    
    
    /*
     4）openURL:方法
     
     UIApplication有个功能十分强大的openURL:方法
     
     - (BOOL)openURL:(NSURL*)url;
     
     openURL:方法的部分功能有
     
     打电话  UIApplication *app = [UIApplicationsharedApplication]; [app openURL:[NSURLURLWithString:@"tel://10086"]];
     
     建议用telprompt://而不用tel://，因为前者有拨打前提示，且拨打完成后回到原先应用界面。
     NSURL *url=[NSURL URLWithString:@"telprompt://10086"];
     [[UIApplication sharedApplication]openURL:url];
     
      跳转到appstore的应用页面去评价。
     ——我们发布应用后，每个应用会有一个Apple ID，根据这个Apple ID可以组成这个地址：id后面？前面的就是Apple ID。
     NSURL *webUrl=[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id791297521?mt=8"];
     [[UIApplication sharedApplication]openURL:webUrl];
     
    
     
     发短信  [app openURL:[NSURLURLWithString:@"sms://10086"]];
     
     发邮件  [app openURL:[NSURLURLWithString:@"mailto://12345@qq.com"]];
     
     打开一个网页资源 [app openURL:[NSURLURLWithString:@"http://ios.itcast.cn"]];
     
     ——地址的编辑也可以通过：先打开这个应用的界面，比如支付宝的网址是：
     https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-zhifubao/id333206289?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4
     接下来，用itms-apps代替http，去除mt=8后面的东西。呃，就行了，最终的地址变成如下，也可实现：
     itms-apps://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-zhifubao/id333206289?mt=8
     
     
     
     打开其他app程序   openURL方法，可以打开其他APP。
     
     URL补充：
     URL：统一资源定位符，用来唯一的表示一个资源。
     URL格式:协议头：//主机地址/资源路径
     网络资源：http/ ftp等   表示百度上一张图片的地址   http://www.baidu.com/images/20140603/abc.png
     本地资源：file:///users/apple/desktop/abc.png(主机地址省略)
     */
    [app openURL:[NSURL URLWithString:@"tel://10086"]];
}

#pragma mark-设置状态栏的样式
/**
 可以通过 [self setNeedsStatusBarAppearanceUpdate] 动态控制
 */

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    //设置为白色
    return UIStatusBarStyleLightContent;
    
    //默认为黑色
    return UIStatusBarStyleDefault;
}

#pragma mark-设置状态栏是否隐藏（否）
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end
