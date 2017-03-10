//
//  BaseNavigationController.m
//  MLLCustomer
//
//  Created by sihuan on 15/4/28.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController


//+ (void) setJMNavigationBarAppearance
//{
//    id appearance = [UINavigationBar appearance];
//    
//    //设置NavigationBar底部横线
//    if ([UINavigationBar instanceMethodForSelector:@selector(setBackgroundImage:)]) {
//        [appearance setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    }
//    if ([UINavigationBar instanceMethodForSelector:@selector(setShadowImage:)]) {
//        [appearance setShadowImage:[self lineImageWithColor:[UIColor colorWithHexString:@"#EEEEEE"]]];
//    }
//    
//}
//
//+ (UIImage *)lineImageWithColor:(UIColor *)color
//{
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGFloat sideLine = 1.0f * scale;
//    CGRect rect = CGRectMake(0.0f, 0.0f, sideLine, sideLine);
//    CGRect topRect = CGRectMake(0.0f, 0.0f, sideLine, sideLine-1.0f);
//    CGRect bottomRect = CGRectMake(0.0f, sideLine-1.0f, sideLine, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//    CGContextFillRect(context, topRect);
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, bottomRect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
//    
//    return image;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTranslucent:NO];
    
    UIColor *whiteColor = [UIColor whiteColor];
    
    self.navigationBar.barTintColor = ColorFlattingBlue;
    self.navigationBar.tintColor = whiteColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:whiteColor};
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.viewControllers.count == 1) {
        return self.statusBarStyle;
    }
        
    return self.topViewController.preferredStatusBarStyle;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
