//
//  UIViewController+Extension.m
//  MySimpleFrame
//
//  Created by sihuan on 15/4/18.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "UIViewController+Extension.h"

@interface YYButton : UIButton
@property (nonatomic, copy)id object;
@end

@implementation YYButton
@end;

@implementation UIViewController (Extension)

- (void)__btnClick:(YYButton *)btn {
    if (btn.object) {
        ((void (^)(UIButton *))btn.object)(btn);
    }
}

#pragma mark - 添加一个button
- (UIButton *)addButtonWithTitle:(NSString *)title action:(void (^)(UIButton *btn)) action {
    YYButton *btn = [YYButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(__btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.object = action;
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
    UIBarButtonItem*backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    [backItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
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

@end
