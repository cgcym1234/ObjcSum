//
//  ViewControllerDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/10.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "ViewControllerDemo.h"

@interface ViewControllerDemo ()

@end

@implementation ViewControllerDemo


#pragma mark - view的创建过程
/**
 *  （2）view的创建过程
 其实上面在创建控制器的时候已经创建了很多视图view。
 ——最简单地就是在storyboard中拖拽一个控制器，里面自带了view。
 ——最简单的还有用代码alloc init一个视图控制器后，也会有.view属性来描述视图。
 ——还有我们通过在xib文件中创建一个视图，并把这个视图连接给一个控制器，那么这个视图也会被加载
 
 （3）那么问题来了：如果这么多视图都有出现，控制器到底先加载哪个视图？
 ——其实大BOSS都不是上面的那些，而是loadView中得视图才是最优先的（即只要视图控制器.m文件中在这个方法中自定义了视图，那么就优先加载这个视图，至于什么storyboard和xib里面的视图都是浮云）有如下代码，那么视图就是绿色的。
 [objc] view plaincopy在CODE上查看代码片派生到我的代码片
 -(void)loadView{
 self.view=[[UIView alloc]init];
 self.view.backgroundColor=[UIColor greenColor];
 }
 
 所以视图创建或者加载的顺序是：
 1、有loadView方法，就加载loadView里的视图view，这个方法就是用来自定义视图的。
 2、如果没有loadView，则先看看有无storyboard，如果有storyboard，就按照storyboard的名称去加载里面的view。
 3、如果没有storyboard，则加载xib里面的view。此时的顺序是：
 3.1、如果指定了xib的名称，则加载响应里面的view；
 3.2、如果没有指定名称，则加载与控制器名称前缀相同的xib里地视图，如控制器名称是WPViewController，那么优先加载名字叫WPView的xib文件里地视图view。
 3.2、其次，如果没有叫WPView的xib文件，则加载与控制器同名的xib里的视图，即加载WPViewController里的view。
 3.3、如果都没有，则加载个空白view。
 
 （4）现象：loadView只调用一次，即第1次打开程序的时候发现没有view，则先去找loadView，如果有的话就创建view，如果没有另找他法。加载过之后，第2次就不会再调用loadView了。所以，如下代码是一个死循环，因为它一直在找view。
 [objc] view plaincopy在CODE上查看代码片派生到我的代码片
 -(void)loadView{
 self.view.backgroundColor=[UIColor greenColor];
 }
 
 （5）记住：控制器的view也是延迟加载的，即用到的时候才加载，也就是调用viewDidLoad方法，可以用打印输入来验证。
 
 （6）还有一种创建xib的方式，就是在创建控制器的同时创建一个xib文件，这个xib文件的名称和视图控制器的名称同名，这也验证了我们上面view加载时候对xib名称的描述。所以命名还是有讲究的，不能随便命名。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
