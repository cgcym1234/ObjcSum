//
//  DemoCellModel2.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "DemoCellModel2.h"
#import "DemoCell2.h"

@implementation DemoCellModel2

- (Class)cellClass {
    return [DemoCell2 class];
}

- (CGFloat)cellHeight {
    return 80;
}

@end
