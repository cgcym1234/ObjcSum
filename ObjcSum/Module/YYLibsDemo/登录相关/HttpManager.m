//
//  HttpManager.m
//  justice
//
//  Created by sihuan on 15/10/17.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "HttpManager.h"

#define IsUseTestUrl 1

#if IsUseTestUrl
#define UrlRoot       @"http://kuaikou.jios.org:7777/justice"
#else
#define UrlRoot       @"http://kuaikou.jios.org:7777/justice"
#endif

#define UrlTasksTodo             UrlRoot@"/mobile/task/todo"
#define UrlTasksAudit            UrlRoot@"/mobile/task/audit"
#define UrlTasksAuth            UrlRoot@"/mobile/auth/cases"
#define UrlLogin                UrlRoot@"/mobile/user/login"

@implementation HttpManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static HttpManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpManager alloc] init];
    });
    return sharedInstance;
}

+ (void)loginWithLoginName:(NSString *)loginName
                  password:(NSString *)password
                   success:(void(^)(LoginModel *loginModel))success
                   failure:(void(^)(NSString *errorString))failure {
//    [[HttpManager sharedInstance] requestWithDelegate:nil method:@"POST" urlString:UrlLogin parameters:@{@"loginName":loginName, @"password": password} headers:nil useCache:NO removeCache:NO cacheExpiration:0 progressBlock:nil completionBlock:^(id responseData, NSError *error, AFHTTPRequestOperation *operation) {
//        if (!error || error.code == 200) {
//            success([[LoginModel alloc] initWithDictionary:responseData]);
//        } else if (error.code == 401) {
//            failure(@"用户名或密码错误！");
//        } else {
//            failure(error.localizedDescription);
//        }
//    }];
}

@end
