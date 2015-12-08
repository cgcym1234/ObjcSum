//
//  LoginDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "LoginDemo.h"
#import "LoginManager.h"

@interface LoginDemo ()

@end

@implementation LoginDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    LoginModel *user = [LoginManager getLatestUserInfo];
    if (!user.sessionId) {
        [LoginManager gotoLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
