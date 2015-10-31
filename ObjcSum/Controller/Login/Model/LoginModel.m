//
//  LoginModel.m
//  justice
//
//  Created by sihuan on 15/10/27.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "LoginModel.h"

static NSString * const KLastestUser = @"KLastestUser";

@implementation LoginModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.deviceId != nil){
        [aCoder encodeObject:self.deviceId forKey:@"deviceId"];
    }
    if(self.email != nil){
        [aCoder encodeObject:self.email forKey:@"email"];
    }
    if(self.loginName != nil){
        [aCoder encodeObject:self.loginName forKey:@"loginName"];
    }
    if(self.mobile != nil){
        [aCoder encodeObject:self.mobile forKey:@"mobile"];
    }
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:@"name"];
    }
    if(self.no != nil){
        [aCoder encodeObject:self.no forKey:@"no"];
    }
    if(self.password != nil){
        [aCoder encodeObject:self.password forKey:@"password"];
    }
    if(self.photo != nil){
        [aCoder encodeObject:self.photo forKey:@"photo"];
    }
    if(self.sessionId != nil){
        [aCoder encodeObject:self.sessionId forKey:@"sessionId"];
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.deviceId = [aDecoder decodeObjectForKey:@"deviceId"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
    self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.no = [aDecoder decodeObjectForKey:@"no"];
    self.password = [aDecoder decodeObjectForKey:@"password"];
    self.photo = [aDecoder decodeObjectForKey:@"photo"];
    self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
    return self;
    
}

#pragma mark - Public

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"deviceId"] isKindOfClass:[NSNull class]]){
        self.deviceId = dictionary[@"deviceId"];
    }
    if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
        self.email = dictionary[@"email"];
    }
    if(![dictionary[@"loginName"] isKindOfClass:[NSNull class]]){
        self.loginName = dictionary[@"loginName"];
    }
    if(![dictionary[@"mobile"] isKindOfClass:[NSNull class]]){
        self.mobile = dictionary[@"mobile"];
    }
    if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"name"];
    }
    if(![dictionary[@"no"] isKindOfClass:[NSNull class]]){
        self.no = dictionary[@"no"];
    }
    if(![dictionary[@"password"] isKindOfClass:[NSNull class]]){
        self.password = dictionary[@"password"];
    }
    if(![dictionary[@"photo"] isKindOfClass:[NSNull class]]){
        self.photo = dictionary[@"photo"];
    }
    if(![dictionary[@"sessionId"] isKindOfClass:[NSNull class]]){
        self.sessionId = dictionary[@"sessionId"];
    }	
    return self;
}


-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.deviceId != nil){
        dictionary[@"deviceId"] = self.deviceId;
    }
    if(self.email != nil){
        dictionary[@"email"] = self.email;
    }
    if(self.loginName != nil){
        dictionary[@"loginName"] = self.loginName;
    }
    if(self.mobile != nil){
        dictionary[@"mobile"] = self.mobile;
    }
    if(self.name != nil){
        dictionary[@"name"] = self.name;
    }
    if(self.no != nil){
        dictionary[@"no"] = self.no;
    }
    if(self.password != nil){
        dictionary[@"password"] = self.password;
    }
    if(self.photo != nil){
        dictionary[@"photo"] = self.photo;
    }
    if(self.sessionId != nil){
        dictionary[@"sessionId"] = self.sessionId;
    }
    return dictionary;
    
}


+ (LoginModel *)get {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:KLastestUser];
    if (data == nil) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
+ (void)update:(LoginModel *)user {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [def setObject:data forKey:KLastestUser];
    [def synchronize];
}
+ (void)reset {
    LoginModel *newUser = [[LoginModel alloc] init];
    LoginModel *userModel = [LoginModel get];
    newUser.loginName = userModel.loginName;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newUser];
    [def setObject:data forKey:KLastestUser];
    [def synchronize];
}
@end
