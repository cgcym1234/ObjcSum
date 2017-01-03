//
//  UIButton+JMCategory.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "UIButton+JMCategory.h"

@implementation UIButton (JMCategory)

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


- (void)setState:(UIControlState)state {
    switch (state) {
        case UIControlStateDisabled:
            self.selected = NO;
            self.enabled = NO;
            break;
        case UIControlStateSelected:
            self.enabled = YES;
            self.selected = YES;
            break;
        default:
            self.enabled = YES;
            self.selected = NO;
            break;
    }
}

@end
