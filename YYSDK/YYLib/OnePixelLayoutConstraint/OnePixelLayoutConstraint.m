//
//  OnePixelLayoutConstraint.m
//  YYSDK
//
//  Created by yangyuan on 2018/1/16.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "OnePixelLayoutConstraint.h"

@implementation OnePixelLayoutConstraint

- (void)awakeFromNib {
    [super awakeFromNib];
	self.constant = 1 / [UIScreen mainScreen].scale;
}

@end
