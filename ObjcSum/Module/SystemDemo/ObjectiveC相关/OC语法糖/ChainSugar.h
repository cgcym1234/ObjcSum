//
//  ChainSugar.h
//  ObjcSum
//
//  Created by yangyuan on 2018/4/25.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChainSugar;

typedef ChainSugar *(^ChainSugarInt)(NSInteger num);
//#define ChainSugarInt(i) ^ChainSugar * (NSInteger i)

///谈谈 Objective-C 链式语法的实现
@interface ChainSugar : NSObject

@property (nonatomic, assign) NSInteger result;

@property (nonatomic, strong, readonly) ChainSugarInt add1;
@property (nonatomic, strong, readonly) ChainSugarInt minus1;

- (ChainSugarInt)add;
- (ChainSugarInt)minus;
- (ChainSugarInt)multiply;
- (ChainSugarInt)divide;

+ (void)test;

@end
