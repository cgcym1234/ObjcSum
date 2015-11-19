//
//  YYHttpRequestSerializer.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/3.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYHttpRequestSerializer.h"
#import "YYBaseHttp.h"

@implementation YYHttpRequestSerializer

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.timeoutInterval = RequestTimeoutInterval;
        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    if (!URLString) {
        NSLog(@"=========RequestWithMethod: ERROR IN Build Request!===== in %s",__FUNCTION__);
        return nil;
    }
    
    NSMutableURLRequest *req = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    [req setCachePolicy:self.cachePolicy];
    
    return req;
}

@end
