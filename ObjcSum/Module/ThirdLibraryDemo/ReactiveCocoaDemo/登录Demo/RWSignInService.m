//
//  RWSignInService.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "RWSignInService.h"


@implementation RWSignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}


@end
