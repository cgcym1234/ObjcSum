//
//  UIButton+JMCategory.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JMCategory)

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

- (void)setState:(UIControlState)state;

@end
