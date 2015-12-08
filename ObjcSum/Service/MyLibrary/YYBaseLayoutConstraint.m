//
//  YYBaseLayoutConstraint.m
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYBaseLayoutConstraint.h"

@implementation YYBaseLayoutConstraint

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant == 1) {
        self.constant = 1/[UIScreen mainScreen].scale;
    }
}

@end
