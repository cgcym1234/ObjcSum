//
//  TabBarController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/5/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@end

@implementation TabBarController

/**
 *  2）UITabBarController有两个子视图，一个是UITabBar部分，它里面放得时UITabBarItem就是下面四个切换的标签那一块。
 另一个是内容部分，就是几个视图。我们点击不同的标签，就会切换显示不同的视图。所以我们加载视图控制器的话，可能在针对视图那一块进行修改。而定制标签的话，是针对UITabBarItem进行修改。
 
 （3）尺寸，UITabBarItem有图片icon也有文字，图片是50*50。具体的参数，点击这里。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 三、UITabBarItem属性介绍及多种创建方式
- (void)UITabBarItemDemo {
    //第一种方式：通过导航控制器的tabBarItem来调用image属性
    UIViewController *vc0=[[UIViewController alloc]init];
    UINavigationController *nav0=[[UINavigationController alloc]initWithRootViewController:vc0];
    //用nav0.tabBarItem.title=@"界面1";来赋值标题时用.title取值取不到，
    //用以下方式赋值标题，可以用.tabBarItem.title取值，但是以下方式直接把navigationItem.title也一并赋值了
    //优先使用以下的方法
    nav0.title=@"界面1";
    //赋值图片
    nav0.tabBarItem.image=[UIImage imageNamed:@"Slice@1x.png"];
    
    
    //第二种方式：通过视图控制器的tabBarItem使用setFinishedSelectedImage方法，设置选中未选中图片状态
    //不过这种方法貌似不被推荐不能使用了，在iOS7中已被抛弃
    //所以推荐使用initWithTitle:image:selectedImage:这个初始化方法
    UIViewController *vc1 = [[UIViewController alloc] init];
    //[vc1.tabBarItem setFinishedSelectedImage:nil withFinishedUnselectedImage:nil];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:nil selectedImage:nil];
    
    //第三种方式：通过视图控制器的tabBarItem来调用image属性
    vc1.tabBarItem.image = nil;
    
    //第四种方式：设置徽标，badgeValue是tabBarItem的一个属性，值是字符串
    vc1.tabBarItem.badgeValue = @"2";
    
#pragma mark - 四、关于tabbar上得More
    
    /**
     *  （1）当标签多余5个时，标签控制器会自动创建一个moreNavigationController，即我们点击More，它是一个导航控制器。
     
     （2）点击More之后我们可以点击编辑，然后通过拖动对应的图标来重新排列它们的显示顺序。
     */
    
#pragma mark - 五、关于英文和中文语言的问题
    
    /**
     *  我们上面的More和Edit都是英文，如何显示成中文呢？需要用到本地化。该程序默认只提供英文一种语言，所以不管用户手机设置成什么语言，只要涉及到系统自带的文字都会是英文。我们需要给程序设置成两种语言（中文和英文），这样程序会根据用户手机的语言设置显示相应的语言。
     
     方法：在Info.plist中增加一个Localizations，并给这个Localizations增加一个选项是简体中文（默认只有英文）。
     
     
     如此，打完收工！（如果你的文字仍然是英文，那么点击CMD+SHIFT+H回到主界面，然后到Setting中去把模拟器语言设置成简体中文即可）
     */
    
    
#pragma mark - 解决方案：TabBar的图片不显示，只显示灰色的正方形
    /**
     *  1）现象
     tabbar上的图片变成一块正方形的灰色块块，原先的图片没有了。
     
     （2）原因
     tabbar上的图片本质上不是一个图片，而是一个形状图片。系统对我们使用的图片也只是把其中的形状“扣”出来，其余的背景什么的都不要。因为我们可能给背景加了颜色，所以系统扣的时候只是把背景扣出来了，我们我们模拟时只看到一个方块，而且还是系统处理过成灰色。
     
     （3）解决方案
     突出形状，淡化背景。
     把背景颜色设置为空。形状随便设置什么颜色。
     */
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"clicked");
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSLog(@"%@",viewController.title);
}

-(void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers{
    NSLog(@"will Customize");
}

-(void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    if (changed) {
        NSLog(@"changed!");
    }else{
        NSLog(@"not changed");
    }
    for (UIViewController *vcs in viewControllers) {
        NSLog(@"%@",vcs.title);
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController DidEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    
}

@end
