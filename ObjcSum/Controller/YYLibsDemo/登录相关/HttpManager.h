//
//  HttpManager.h
//  justice
//
//  Created by sihuan on 15/10/17.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "YYBaseHttp.h"
#import "LoginModel.h"

@interface HttpManager : YYBaseHttp

+ (instancetype)sharedInstance;

+ (void)loginWithLoginName:(NSString *)loginName
                  password:(NSString *)password
                   success:(void(^)(LoginModel *loginModel))success
                   failure:(void(^)(NSString *errorString))failure;

@end
