//
//  MyClass1.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MyClass1.h"

@interface MyClass1 () {
    NSInteger _instance1;
    NSString *_instance2;
}

@property (nonatomic, assign) NSInteger interger;
- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass1

+ (void)classMethod {
    NSLog(@"%s", __FUNCTION__);
}

- (void)method1 {
    NSLog(@"%s", __FUNCTION__);
}

- (void)method2 {
    NSLog(@"%s", __FUNCTION__);
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end























