//
//  NSStringDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2016/12/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSStringDemo.h"

@implementation NSStringDemo


- (void)rangeTest {
    //如果string是一个nil或者Null就会出现这种情况:
    NSString *string;
    NSLog(@"length = %lu, location = %lu", (unsigned long)[string rangeOfString:@"A"].length, (unsigned long)[string rangeOfString:@"A"].location);
    //打印结果:length = 0, location = 0
    //那么location = 0,所以location != NSNotFound,因为NSNotFound就是Integer最大的值:NSIntegerMax
}

@end




















