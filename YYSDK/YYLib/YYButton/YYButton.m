//
//  YYButton.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYButton.h"

IB_DESIGNABLE
@implementation YYButton

#pragma mark - IBDesignable

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
        self.layer.masksToBounds = YES;
    }
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}



@end
