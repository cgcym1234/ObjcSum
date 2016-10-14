//
//  UIViewController+Extension.m
//  MySimpleFrame
//
//  Created by sihuan on 15/4/18.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@interface _YYButton : UIButton
@property (nonatomic, copy)id object;
@end

@implementation _YYButton
@end;

static char KeyBarThemeType;
static char kButtonCount;

@interface UIViewController ()

@property (nonatomic, assign) NSInteger buttonCount;

@end


@implementation UIViewController (Extension)

#pragma mark - TopViewController

//获取app当前最顶层的ViewController
+ (UIViewController *)appTopViewController {
    UIViewController *resultVC;
    resultVC = [[UIApplication sharedApplication].keyWindow rootViewController].showingViewController;
    while (resultVC.presentedViewController) {
        resultVC = resultVC.presentedViewController.showingViewController;
    }
    return resultVC;
}

/**< 3种情况
 1. UINavigationController.topViewController
 2. UITabBarController.selectedViewController
 3. UIViewController 自己
 */
- (UIViewController *)showingViewController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self topViewController].showingViewController;
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)self selectedViewController].showingViewController;
    } else {
        return self;
    }
}

- (void)__btnClick:(_YYButton *)btn {
    if (btn.object) {
        ((void (^)(UIButton *))btn.object)(btn);
    }
}

- (NSInteger)buttonCount {
    return [objc_getAssociatedObject(self, &kButtonCount) integerValue];
}

- (void)setButtonCount:(NSInteger)buttonCount {
    objc_setAssociatedObject(self, &kButtonCount, @(buttonCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 添加一个button

- (UIButton *)addButtonWithTitle:(NSString *)title action:(void (^)(UIButton *btn)) action {
    _YYButton *btn = [_YYButton buttonWithType:UIButtonTypeSystem];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(__btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.object = action;
    btn.frame = CGRectMake(0, 40 * ++self.buttonCount, CGRectGetWidth([UIScreen mainScreen].bounds), 40);
    [self.view addSubview:btn];
    return btn;
}

#pragma mark - 打电话
- (void)phoneCall:(NSString *)phone {
    if (!phone) {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];
}

#pragma mark - 弹出alertView
- (UIAlertView *)showAlert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    return alert;
}

#pragma mark - 根据名字得到Storyboard
- (UIStoryboard *)getStoryboard:(NSString *)name {
    return [UIStoryboard storyboardWithName:name bundle:nil];
}

#pragma mark - 根据Storyboard名字和vcid得到 UIViewController
- (UIViewController *)getVCFromStoryboard:(NSString *)sbName vcId:(NSString *)vcId {
    UIStoryboard *sb = self.storyboard;
    if (sbName) {
        sb = [self getStoryboard:sbName];
    }
    
    return [sb instantiateViewControllerWithIdentifier:vcId];
}

#pragma mark - 隐藏NavigationBar底部的那条黑线
//NavigationBar底部的黑线是一个UIImageView上的UIImageView。
- (void)setNavigationBarBottomLineHidden:(BOOL)hidden {
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=hidden;
                    }
                }
            }
        }
    }
    
    //或者 [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - 修改NavigationBar返回按钮，同时不会导致返回手势失效
- (void)setBackBarButtonItemWithImage:(UIImage *)image {
    //防止ios9 下图片被拉伸
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)];
    
    UIBarButtonItem*backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [backItem setBackButtonBackgroundImage:newImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}


- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, image.size.width <= 25 ? 25 : image.size.width, image.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [array addObject:item];
    self.navigationItem.leftBarButtonItems = array;
}

- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, image.size.width <= 25 ? 25 : image.size.width, image.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [array addObject:item];
    self.navigationItem.rightBarButtonItems = array;
}

#pragma mark - 导航BarButtonItem文字或者图片与屏幕边界的间隔调整方法

/**
 在设置navigationItem的leftBarButtonItem或rightBarButtonItem时，
 用CustomView初始化UIBarButtonItem，不论怎么设置CustomView的frame，
 添加到导航条上之后总是和屏幕边界有一定的间距（5pix），
 如何自由调整这个间距呢？
 */

//1、不用直接设置rightBartButtonItem而是设置rightBartButtonItems，并且第一个item设置为一个占位。
- (UIButton *)addRightBarButtonItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    //! 这里需要根据内容大小来调整宽度
    button.frame = CGRectMake(0, 0, size.width <= 10 ? 70 : size.width + 10, 44);
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:title forState:UIControlStateNormal];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
    return button;
}

/**
 *  2、如果是只有图片，那么通过设置
 [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, -15)];这样也可以调整
 */
- (UIButton *)addRightBarButtonItemWithImage:(NSString *)imageName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    return button;  
}



#pragma mark - 设置导航条主题
- (NavigationControllerBarThemeType)barThemeType {
    return [objc_getAssociatedObject(self, &KeyBarThemeType) integerValue];
}

- (void)setBarThemeType:(NavigationControllerBarThemeType)barThemeType {
    objc_setAssociatedObject(self, &KeyBarThemeType, @(barThemeType), OBJC_ASSOCIATION_ASSIGN);
}
- (void)setNavagationBarTheme:(NavigationControllerBarThemeType)type {
    UIColor *barTintColor;
    UIColor *tintColor;
    UIColor *titleColor;
    UIColor *leftBarbartemColor;
    switch (type) {
        case NavigationControllerBarThemeTypeWhite:
            barTintColor = [UIColor whiteColor];
            tintColor = [UIColor blackColor];
            titleColor = [UIColor blackColor];
            leftBarbartemColor = [UIColor blackColor];
            break;
        case NavigationControllerBarThemeTypeGreen:
            barTintColor = [UIColor colorWithRed:49.f/255.f green:189.f/255.f blue:198.f/255.f alpha:0.8f];
            tintColor = [UIColor whiteColor];
            titleColor = [UIColor whiteColor];
            leftBarbartemColor = [UIColor whiteColor];
            break;
    }
    
    self.barThemeType = type;
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self navigationBar].barTintColor = barTintColor;
        [(UINavigationController *)self navigationBar].tintColor = tintColor;
        [(UINavigationController *)self navigationBar].titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    self.navigationController.navigationBar.barTintColor = barTintColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
    self.navigationItem.leftBarButtonItem.tintColor = leftBarbartemColor;
}





















@end
