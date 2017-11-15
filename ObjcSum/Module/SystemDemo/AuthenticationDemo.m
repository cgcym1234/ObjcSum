//
//  AuthenticationDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/7/22.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "AuthenticationDemo.h"
#import "UIViewController+Extension.h"
#import "YYSDK.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AuthenticationDemo ()

@end

@implementation AuthenticationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"指纹解锁" action:^(UIButton *btn) {
        [weakSelf showAuthenticate:@"指纹解锁"];
    }];
}

- (void)showAuthenticate:(NSString *)message {
    LAContext *context = [LAContext new];
    NSError *error;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"enter LAPolicyDeviceOwnerAuthenticationWithBiometrics ------- %@", error);
        
        //localizedReason: 指纹识别出现时的提示文字
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //识别成功, 在主线程中，处理
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"LAPolicyDeviceOwnerAuthenticationWithBiometrics success ------- %@", error);
                    
                });
            } else {
                NSLog(@"LAPolicyDeviceOwnerAuthenticationWithBiometrics  error ------- %@", error);
            }
        }];
    } else if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        NSLog(@"enter LAPolicyDeviceOwnerAuthentication ------- %@", error);
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //识别成功, 在主线程中，处理
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"LAPolicyDeviceOwnerAuthentication success ------- %@", error);
                    
                });
            } else {
                NSLog(@"LAPolicyDeviceOwnerAuthentication  error ------- %@", error);
            }
        }];
    } else {
        NSLog(@"error ------- %@", error);
    }
}

@end


























