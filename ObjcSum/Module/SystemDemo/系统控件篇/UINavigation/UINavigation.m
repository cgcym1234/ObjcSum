//
//  UINavigation.m
//  UI控件
//
//  Created by michael chen on 14-9-24.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UINavigation.h"
#import "UIImage+Extension.h"

@interface UINavigation ()<UINavigationControllerDelegate>

@end

@implementation UINavigation

/*
UINavigationController切换视图有两种方式
第一种：从侧面切换视图
[self.navigationController pushViewController:viewController2 animated:YES];
如果用push退出的viewController，返回的时候只能用pop函数，即push函数对应pop函数
[self.navigationController popViewControllerAnimated:YES];
[self.navigationController popToViewController:destViewController animated:YES];
[self.navigationController popToRootViewControllerAnimated:YES];

第二种：从下往上切换视图
[self.navigationController presentViewController:viewController2 animated:YES completion:nil];
当使用present函数切换视图的时候，不显示导航栏
对应
[self.navigationController dismissViewControllerAnimated:YES completion:nil];
*/

/*
 如果不用UINavigationController，那么切换视图只能用present函数和dismiss函数，是用viewController来切换
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    #pragma mark - 1、navigationItem
    /*
     1、navigationItem
     　　navigationItem是UIViewController的一个属性，这个属性是为UINavigationController服务的。
     文档中是这么解释的“The navigation item used to represent the view controller in a parent’s navigation bar. (read-only)”，
     即navigation item在navigation Bar代表一个viewController，
     具体一点儿来说就是每一个加到navigationController的viewController都会有一个对应的navigationItem，
     该对象由viewController以懒加载的方式创建，稍后我们可以在对象中堆navigationItem进行配置，

     注意添加该prompt描述以后NavigationBar的高度会增加30，总的高度会变成74(不管当前方向是Portrait还是Landscape，此模式下navgationbar都使用高度44加上prompt30的方式进行显示)。
     当然如果觉得只是设置文字的title不够爽，你还可以通过titleview属性指定一个定制的titleview，
     */
    self.navigationItem.prompt = @"prompt test";
    
 #pragma mark - 2、titleTextAttributes（ios5.0以后可用）
    /*
     2、titleTextAttributes（ios5.0以后可用）
     　　这是UINavigationBar的一个属性，通过它你可以设置title部分的字体
     　　下面看一个简单的例子：
     */
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor redColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
 
    
    //设置UINavigationBar全透明, 此处随便设置一张图片即可，重要的是BarMetrics属性决定了bar的样式
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bg"] forBarMetrics:UIBarMetricsCompact];
    
    #pragma mark - 4、navigationBar中的stack
    /*
     4、navigationBar中的stack
     　　这个属性可以算是UINavigationController的灵魂之一，
     它维护了一个和UINavigationController中viewControllers对应的navigationItem的stack，该stack用于负责navigationbar的刷新。
     “注意：如果navigationbar中navigationItem的stack和对应的NavigationController中viewController的stack是一一对应的关系，
     如果两个stack不同步就会抛出异常。
     
     　　当pushViewcontroller的之后，强制把navigationBar中的navigationItem pop一个出去，程序立马挂起。
     下面举个简单抛出异常的例子：
     */
    [self.navigationController.navigationBar popNavigationItemAnimated:YES];
   
    #pragma mark - 5、navigationBar的刷新
    /*
     5、navigationBar的刷新
     
     　　通过前面介绍的内容，我们知道navigationBar中包含了这几个重要组成部分：leftBarButtonItem, rightBarButtonItem, backBarButtonItem, title。
     当一个view controller添加到navigationController以后，navigationBar的显示遵循一下几个原则：
     
     　　1）、Left side of the navigationBar
     　　a）如果当前的viewController设置了leftBarButtonItem，则显示当前VC所自带的leftBarButtonItem。
     　　b）如果当前的viewController没有设置leftBarButtonItem，且当前VC不是rootVC的时候，则显示前一层VC的backBarButtonItem。
     如果前一层的VC没有显示的指定backBarButtonItem的话，系统将会根据前一层VC的title属性自动生成一个back按钮，并显示出来。
     　　c）如果当前的viewController没有设置leftBarButtonItem，且当前VC已是rootVC的时候，左边将不显示任何东西。
     
     　　此处注意：5.0中新增加了一个属性leftItemsSupplementBackButton，通过指定该属性为YES，可以让leftBarButtonItem和backBarButtonItem同时显示，
     其中leftBarButtonItem显示在backBarButtonItem的右边。
     
     　　2)、title部分
     　　a）如果当前VC通过 .navigationItem.titleView指定了自定义的titleView，系统将会显示指定的titleView，
     此处要注意自定义titleView的高度不要超过navigationBar的高度，否则会显示出界。
     　　b）如果当前VC没有指定titleView，系统则会根据当前VC的title或者当前VC的navigationItem.title的内容创建一个UILabel并显示，
     其中如果指定了navigationItem.title的话，则优先显示navigationItem.title的内容。
     
     　　3)、Right side of the navigationBar
     　　a）如果当前VC指定了rightBarButtonItem的话，则显示指定的内容。
     　　b）如果当前VC没有指定rightBarButtonItem的话，则不显示任何东西。
     */
    //self.navigationItem.title = @"self.navigationItem.title";
    self.title = @"self.title";
 
    #pragma mark - 6、Toolbar
    /*
     6、Toolbar
     　　navigationController自带了一个工具栏，通过设置 self.navigationController.toolbarHidden = NO来显示工具栏，
     工具栏中的内容可以通过viewController的toolbarItems来设置，显示的顺序和设置的NSArray中存放的顺序一致，
     其中每一个数据都一个UIBarButtonItem对象，可以使用系统提供的很多常用风格的对象，也可以根据需求进行自定义。
     默认是在最下面，
     */
    
    //设置toolbarHidden隐藏和显示，两种方法均可
    self.navigationController.toolbarHidden=NO;
    [self.navigationController setToolbarHidden:NO animated:YES];
    //设置toolbarHidden背景颜色
    [self.navigationController.toolbar setBarTintColor:[UIColor redColor]];
    //这个貌似没有用（设置背景的）
    [self.navigationController.toolbar setBackgroundColor:[UIColor orangeColor]];
    //设置toolbarHidden样式，黑色，黑色透明等等，但貌似都是半透明效果
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
    //设置toolbarHidden背景图片，forToolbarPosition是位置状态是放在什么地方时显示设置它的位置，UIBarMetricsDefault是状态设置在竖屏还是横屏时显示
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    //可以设置位置，但貌似无效果
    self.navigationController.toolbar.frame=CGRectMake(0, 0, 375, 44);
    
    /**
     //重点是设置上面的按钮这些
     //和设置navigationBarItem类似
     //先设置一个UIBarButtonItem，然后组成数组，然后把这个数组赋值给self.toolbarItems
     
     */
    
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
    UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    UIBarButtonItem *four = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three, flexItem, four, flexItem, nil]];
    //self.navigationController.toolbar.hidden = NO;
    [self.navigationController setToolbarHidden:NO];
    
    #pragma mark - 8、UINavigationController的viewControllers属性
    /*
     8、UINavigationController的viewControllers属性
     　　通过该属性我们可以实现一次性替换整个navigationController的层次, 
     这个过程如果通过setViewControllers:animated:来设置，并指定动画为YES的画，
     动画将会从当前的navigationController所显示的vc跳转到所设置的目标viewController的最顶层的那个VC，而中间其他的VC将会被直接从VC层级中移除和添加进来（没有动画）。
     */
    
    #pragma mark - 9、topViewController Vs visibleViewController
    /*
     9、topViewController Vs visibleViewController
     　　topViewController代表当前navigation栈中最上层的VC，而visibleViewController代表当前可见的VC，
     它可能是topViewController，也可能是当前topViewController present出来的VC。因此UINavigationController的这两个属性通常情况下是一样，但也有可能不同。
     */

}

#pragma mark -- UINavigationControllerDelegate 委托方法
/**
 *  在该viewController被push入栈的时候时候会调用一次，      这时 参数viewController是自己，
    当pop 或继续push其他viewController时候，会再次被调用，  这时 参数viewController是另外一个viewController，
 *  所以可以通过这样可以交换数据，很方便，遇到个莫名的crash的问题，需要在上一个viewController将 self.navigationController.delegate=nil 才行
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[UINavigation class]]) {
        //
    } else if ([viewController isKindOfClass:[UIViewController class]]){
        //
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}


+ (void)setTheme {
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

#pragma mark - 设置UINavigationBar的主题
+ (void)setupNavigationBarTheme
{
    //通过设置appearance对象，能够修改整个项目中所有UINavigationBar的样式
    UINavigationBar *appearance=[UINavigationBar appearance];
    
    //设置不透明, Bar的模糊效果，默认为YES
    [appearance setTranslucent:NO];
    //[appearance setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    /*
     新的问题：
     
     模拟器在切换到ios7之后，导航栏下角有一条阴影线。是因为ios中，66-64多出了2个像素点。把导航栏的背景去掉后，即可解决。
     在设置导航栏背景的时候，进行一次判断，如果是ios7那么就不设置导航栏背景。
     */
    
    /*
     设置导航栏的背景
     setBackgroundImage方法的第二个参数，需要解释一下：
     UIBarMetricsDefault：用竖着（拿手机）时UINavigationBar的标准的尺寸来显示UINavigationBar
     UIBarMetricsLandscapePhone：用横着时UINavigationBar的标准尺寸来显示UINavigationBar
     */
    //    if (!IOS7) {
    //        [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    //    }
    
    
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [appearance setTitleTextAttributes:attris];
    
    
    /*
     设置文字属性  UITextAttributeTextColor这些等在ios7中过期了,
     使用NSFontAttributeName替代,但是使用了NSFontAttributeName,在ios6中又无效...
     */
    //    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    //    //设置字体颜色
    //    textAttrs[UITextAttributeTextColor]=[UIColor blackColor];
    //    //设置字体
    //    textAttrs[UITextAttributeFont]=[UIFont boldSystemFontOfSize:20];
    //    //设置字体的偏移量（0）
    //    //说明：UIOffsetZero是结构体，只有包装成NSValue对象才能放进字典中
    //    textAttrs[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
    //    [appearance setTitleTextAttributes:textAttrs];
}

#pragma mark - 设置UIBarButtonItem的主题
+ (void)setupBarButtonItemTheme{
    
    //通过设置appearance对象，能够修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    
    //设置文字的属性
    //1.设置普通状态下文字的属性
    NSDictionary *textAttrNormal = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     NSShadowAttributeName:[NSValue valueWithUIOffset:UIOffsetZero],
                                     NSForegroundColorAttributeName:[UIColor orangeColor]
                                     };
    
    //2.设置普通状态下文字的属性
    NSMutableDictionary *textAttrHighlight = [NSMutableDictionary dictionaryWithDictionary:textAttrNormal   ];
    textAttrHighlight[NSForegroundColorAttributeName]=[UIColor redColor];
    
    //3.设置不可用状态下文字的属性
    NSMutableDictionary *textAttrDisable = [NSMutableDictionary dictionaryWithDictionary:textAttrNormal   ];
    textAttrDisable[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    
    [barButtonItem setTitleTextAttributes:textAttrNormal forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:textAttrHighlight forState:UIControlStateHighlighted];
    [barButtonItem setTitleTextAttributes:textAttrDisable forState:UIControlStateDisabled];
    
    //设置背景
    //技巧提示：为了让某个按钮的背景消失，可以设置一张完全透明的背景图片
    //[appearance setBackButtonBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"]forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}



#pragma mark - 设置UITabBar的主题
+ (void)setupTabBarTheme {
    //通过设置appearance对象，能够修改整个项目中所有UITabBar的样式
    UITabBar *appearance = [UITabBar appearance];
    
    //设置不透明, Bar的模糊效果，默认为YES
    [appearance setTranslucent:NO];
    //[appearance setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
}


@end
