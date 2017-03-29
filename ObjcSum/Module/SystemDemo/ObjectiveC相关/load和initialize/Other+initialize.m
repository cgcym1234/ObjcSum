//
//  Other+initialize.m
//  Load+Initialize
//
//  Created by mjpc on 2017/2/26.
//  Copyright © 2017年 mali. All rights reserved.
//

#import "Other+initialize.h"

@implementation Other(initialize)

+ (void)load {
    //    NSLog(@"Other+initialize:%s %@", __FUNCTION__, [self class]);
    NSLog(@"Other+initialize:%s %@", __FUNCTION__, @"Other+initialize");
}

+ (void)initialize {
//    NSLog(@"Other+initialize:%s %@", __FUNCTION__, [self class]);
    NSLog(@"Other+initialize:%s %@", __FUNCTION__, @"Other+initialize");
}

@end
