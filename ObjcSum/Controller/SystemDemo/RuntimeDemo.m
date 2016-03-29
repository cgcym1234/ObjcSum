//
//  RuntimeDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "RuntimeDemo.h"
#import "MethodForword.h"

@implementation RuntimeDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MethodForword new] test];
    [MethodForword test];
}

@end
