//
//  UIColor+Extention.m
//  MLLCustomer
//
//  Created by sihuan on 15/5/8.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "UIColor+Extention.h"

@implementation UIColor (Extention)

#pragma mark - 将16进制颜色转换成UIColor
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned long colorLong = strtoul(hexString.UTF8String, 0, 16);
    int R = (colorLong & 0xFF0000) >> 16;
    int G = (colorLong & 0x00FF00) >> 8;
    int B = colorLong & 0x0000FF;
    
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.f];
}

#pragma mark - UIColor 转换成 NSString
- (NSString *)stringFromColorSelf {
    const size_t totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int)(255 * components[MIN(0,totalComponents-2)]),
            (int)(255 * components[MIN(1,totalComponents-2)]),
            (int)(255 * components[MIN(2,totalComponents-2)])];
}
@end
