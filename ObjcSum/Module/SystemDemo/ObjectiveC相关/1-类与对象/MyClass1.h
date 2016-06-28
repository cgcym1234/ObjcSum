//
//  MyClass1.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass1 : NSObject

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *string;

- (void)method1;
- (void)method2;

+ (void)classMethod;

@end