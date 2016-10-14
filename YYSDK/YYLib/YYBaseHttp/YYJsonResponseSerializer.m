//
//  YYJsonResponseSerializer.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/3.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYJsonResponseSerializer.h"

@implementation YYJsonResponseSerializer

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSMutableSet *customContentTypes = [self.acceptableContentTypes mutableCopy];
        [customContentTypes addObject:@"text/html"];
        [customContentTypes addObject:@"text/plain"];
        [customContentTypes addObject:@"text/json"];
        [customContentTypes addObject:@"application/json"];
        self.acceptableContentTypes = [customContentTypes copy];
    }
    return self;
}

@end
