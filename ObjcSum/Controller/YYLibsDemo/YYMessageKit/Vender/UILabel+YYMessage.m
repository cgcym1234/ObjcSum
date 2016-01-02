//
//  UILabel+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UILabel+YYMessage.h"

@implementation UILabel (YYMessage)

+ (UILabel *)labelAlignmentCenter {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font            = [UIFont systemFontOfSize:14.f];
    label.textColor       = [UIColor lightGrayColor];
    return label;
}

@end
