//
//  UIButton+YYSDK.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIButton+YYSDK.h"
#import "UIImage+YYSDK.h"

@implementation UIButton (YYSDK)

#pragma mark - Title

- (void)setTitleAll:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
}
- (void)setTitleNormal:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleHighlighted:(NSString *)title {
    [self setTitle:title forState:UIControlStateHighlighted];
}
- (void)setTitleDisabled:(NSString *)title {
    [self setTitle:title forState:UIControlStateDisabled];
}
- (void)setTitleSelected:(NSString *)title {
    [self setTitle:title forState:UIControlStateSelected];
}

- (NSString *)titleNomal {
    return [self titleForState:UIControlStateNormal];
}
- (NSString *)titleHighlighted {
    return [self titleForState:UIControlStateHighlighted];
}
- (NSString *)titleDisabled {
    return [self titleForState:UIControlStateDisabled];
}
- (NSString *)titleSelected {
    return [self titleForState:UIControlStateSelected];
}

#pragma mark - 设置背景色

- (void)setBackgroundColorNomal:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
}
- (void)setBackgroundColorHighlighted:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateHighlighted];
}
- (void)setBackgroundColorDisabled:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateDisabled];
}
- (void)setBackgroundColorSelected:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateSelected];
}
@end




















