//
//  YYMultiSelectModel.m
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "YYMultiSelectModel.h"

@implementation YYMultiSelectModel

/**
 *      checked = 0;
 id = 4f41637194f443d3bc701b3f6849d782;
 name = "\U9a6c\U8d85";
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _tid = dictionary[@"id"];
        _name = dictionary[@"name"];
        _checked = [dictionary[@"checked"] boolValue];
    }
    return self;
}

@end
