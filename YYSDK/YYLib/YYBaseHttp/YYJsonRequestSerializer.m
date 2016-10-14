//
//  YYJsonRequestSerializer.m
//  ObjcSum
//
//  Created by sihuan on 15/11/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYJsonRequestSerializer.h"
#import "YYBaseHttp.h"

@implementation YYJsonRequestSerializer

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.timeoutInterval = RequestTimeoutInterval;
        [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    return self;
}

@end
