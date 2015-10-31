//
//  LoginModel.h
//  justice
//
//  Created by sihuan on 15/10/27.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *sessionId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

+ (LoginModel *)get;
+ (void)update:(LoginModel *)user;
+ (void)reset;

@end
