//
//  LoginManager.h
//  justice
//
//  Created by sihuan on 15/10/27.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

//账号登录客户端成功
#define Notify_LoginSuccess                   @"Notify_LoginSuccess"
//退出客户端
#define Notify_LogOut                         @"Notify_LogOut"

@interface LoginManager : NSObject

@property (readonly, nonatomic) BOOL isLogin;
@property (readonly, nonatomic) LoginModel *loginModel; //已登录用户信息

+ (instancetype)sharedInstance;

+ (void)loginSuccessWithUserInfo:(LoginModel *)loginModel;

/** 获取最近一次登录成功的用户信息。*/
+ (LoginModel *)getLatestUserInfo;
/** 保存最近一次登录成功的用户信息。*/
+ (void)updateUserInfo:(LoginModel *)user;
/** 重置用户数据*/
- (void)resetUserInfo;

+ (void)gotoLogin;
+ (void)gotoLoginFromViewController:(UIViewController *)fromVc;
+ (void)logout;


@end
