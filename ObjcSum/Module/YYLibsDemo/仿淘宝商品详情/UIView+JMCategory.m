//
//  UIView+JMCategory.m
//  JuMei
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "UIView+JMCategory.h"
#import "YYHud.h"

@implementation UIView (JMCategory)

- (void)showTip:(NSString *)tip {
    [self showTip:tip animated:YES];
}

- (void)showTip:(NSString *)tip animated:(BOOL)animated {
    [self showTip:tip animated:YES duration:3.0];
}

- (void)showTip:(NSString *)tip animated:(BOOL)animated duration:(CGFloat)duration {
    [YYHud showTip:tip duration:duration];
}

+ (UINib *)jm_nib {
    return [UINib nibWithNibName:[self jm_identifier] bundle:nil];
}
+ (NSString *)jm_identifier {
    return NSStringFromClass(self);
}


- (CALayer *)addBorderTopPadding:(CGFloat)padding height:(CGFloat)height color:(UIColor *)color {
    return [self addBorderAtX:padding y:0 width:self.frame.size.width - 2*padding height:height color:color];
}
- (CALayer *)addBorderBottomPadding:(CGFloat)padding height:(CGFloat)height color:(UIColor *)color {
    return [self addBorderAtX:padding y:self.frame.size.height - height width:self.frame.size.width - 2*padding height:height color:color];
}
- (CALayer *)addBorderAtX:(CGFloat)x
                   y:(CGFloat)y
               width:(CGFloat)width
              height:(CGFloat)height
               color:(UIColor *)color {
    CALayer *border = [CALayer new];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(x, y, width, height);
    [self.layer addSublayer:border];
    return border;
}

#pragma mark - Shadow
- (void)addShadowOffset:(CGSize)offset
                 radius:(CGFloat)radius
                opacity:(CGFloat)opacity
                  color:(UIColor *)color {
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = [color CGColor];
}

@end



















