//
//  LoginManager.m
//  justice
//
//  Created by sihuan on 15/10/27.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "LoginManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
//#import "HttpManager.h"

@interface LoginManager ()

@end

@implementation LoginManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginManager *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LoginManager alloc] init];
    });
    return _sharedInstance;
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
}

- (void)setLoginModel:(LoginModel *)loginModel {
    _loginModel = loginModel;
    [LoginModel update:loginModel];
}

#pragma mark - Public

+ (void)loginSuccessWithUserInfo:(LoginModel *)loginModel {
    [LoginManager sharedInstance].isLogin = YES;
    [LoginManager sharedInstance].loginModel = loginModel;
}

/** 获取最近一次登录成功的用户信息。*/
+ (LoginModel *)getLatestUserInfo {
    LoginModel *user = [LoginModel get];
    if (user) {
        [LoginManager sharedInstance].isLogin = YES;
        [LoginManager sharedInstance].loginModel = user;
    }
    return user;
}
/** 保存最近一次登录成功的用户信息。*/
+ (void)updateUserInfo:(LoginModel *)user {
    [LoginModel update:user];
}
/** 重置用户数据*/
- (void)resetUserInfo {
    self.isLogin = NO;
    self.loginModel = nil;
    [LoginModel reset];
}

+ (void)gotoLogin {
    __block UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelNormal;
    
    LoginViewController *loginVc = [LoginViewController instanceFromStoryboardWithCompletion:^(LoginViewController *vc, BOOL isLoginSuccess) {
        window.hidden = YES;
        window = nil;
    }];
    window.rootViewController = loginVc;
    [window makeKeyAndVisible];
}

+ (void)gotoLoginFromViewController:(UIViewController *)fromVc {
    LoginViewController *loginVc = [LoginViewController instanceFromStoryboard];
    [fromVc presentViewController:loginVc animated:YES completion:nil];
}

+ (void)logout {
    [[self sharedInstance] setIsLogin:NO];
    [[self sharedInstance] resetUserInfo];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_LogOut object:nil];
}

@end
