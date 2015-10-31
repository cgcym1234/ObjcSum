//
//  LoginViewController.h
//  justice
//
//  Created by sihuan on 15/10/25.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
typedef void (^LoginViewControllerCompletionBlock)(LoginViewController *vc, BOOL isLoginSuccess);

@interface LoginViewController : UIViewController

+ (instancetype)instanceFromStoryboard;
+ (instancetype)instanceFromStoryboardWithCompletion:(LoginViewControllerCompletionBlock)completion;

@end
