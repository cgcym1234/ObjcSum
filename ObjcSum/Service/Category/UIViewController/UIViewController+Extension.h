//
//  UIViewController+Extension.h
//  MySimpleFrame
//
//  Created by sihuan on 15/4/18.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

#pragma mark - 添加一个button
- (UIButton *)addButtonWithTitle:(NSString *)title action:(void (^)(UIButton *btn)) action;

#pragma mark - 弹出alertView
- (UIAlertView *)showAlert:(NSString *)text;

#pragma mark - 打电话
- (void)phoneCall:(NSString *)phone;

#pragma mark - 根据名字得到Storyboard
- (UIStoryboard *)getStoryboard:(NSString *)name;

#pragma mark - 根据Storyboard名字和vcid得到 UIViewController
- (UIViewController *)getVCFromStoryboard:(NSString *)name vcId:(NSString *)vcId;

#pragma mark - 隐藏NavigationBar底部的那条黑线
- (void)setNavigationBarBottomLineHidden:(BOOL)hidden;

#pragma mark - 修改NavigationBar返回按钮，同时不会导致返回手势失效
- (void)setBackBarButtonItemWithImage:(UIImage *)image;

- (void)addRightBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
- (void)addLeftBarButtonItemWithTarget:(id)target sel:(SEL)selector image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
