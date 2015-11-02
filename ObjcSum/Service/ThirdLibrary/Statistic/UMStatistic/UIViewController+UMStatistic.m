//
//  UIViewController+UMStatistic.m
//  MLLCustomer
//
//  Created by sihuan on 15/6/23.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "UIViewController+UMStatistic.h"
//#import "MobClick.h"
#import <objc/runtime.h>

static char KeyTitleForUMStatistic;

@implementation UIViewController (UMStatistic)

//用于友盟统计页面停留时长
- (NSString *)titleForUMStatistic {
    return objc_getAssociatedObject(self, &KeyTitleForUMStatistic);
}

- (void)setTitleForUMStatistic:(NSString *)titleForUMStatistic {
    objc_setAssociatedObject(self, &KeyTitleForUMStatistic, titleForUMStatistic, OBJC_ASSOCIATION_ASSIGN);
}

//用于友盟统计自定义事件
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number {
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
//    [MobClick event:eventId attributes:mutableDictionary];
}

@end
