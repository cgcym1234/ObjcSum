//
//  UIButton+YYSDK.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YYSDK)

#pragma mark - Title

- (void)setTitleAll:(NSString *)title;
- (void)setTitleNormal:(NSString *)title;
- (void)setTitleHighlighted:(NSString *)title;
- (void)setTitleDisabled:(NSString *)title;
- (void)setTitleSelected:(NSString *)title;

- (NSString *)titleNomal;
- (NSString *)titleHighlighted;
- (NSString *)titleDisabled;
- (NSString *)titleSelected;

#pragma mark - 背景色

- (void)setBackgroundColorNomal:(UIColor *)color;
- (void)setBackgroundColorHighlighted:(UIColor *)color;
- (void)setBackgroundColorDisabled:(UIColor *)color;
- (void)setBackgroundColorSelected:(UIColor *)color;

@end
