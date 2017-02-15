//
//  JMSkuSelectedViewModel+Network.m
//  ObjcSum
//
//  Created by yangyuan on 2017/1/3.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel+Network.h"

@implementation JMSkuSelectedViewModel (Network)

+ (JMSkuModel *)requestData {
    NSString *mockData = [[NSBundle mainBundle] pathForResource:@"JMSkuMockData3" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:mockData];
    JMSkuModel *skuModel = [[JMSkuModel alloc] initWithDictionary:dict];
    return skuModel;
}

@end
