//
//  UIColor+YYSDK.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIColor+YYSDK.h"

@implementation UIColor (YYSDK)

/* 随机色 */
+ (instancetype)random {
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}

/**< 将16进制 @"0x666666" 转换成UIColor */
+ (instancetype)colorWithHexString:(NSString *)hexString {
    unsigned long colorLong = strtoul(hexString.UTF8String, 0, 16);
    int R = (colorLong & 0xFF0000) >> 16;
    int G = (colorLong & 0x00FF00) >> 8;
    int B = colorLong & 0x0000FF;
    
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.f];
}
/**< UIColor 转换成 @"0x666666" */
- (NSString *)hexString {
    const size_t totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return [NSString stringWithFormat:@"#%02X%02X%02X",
            (int)(255 * components[MIN(0,totalComponents-2)]),
            (int)(255 * components[MIN(1,totalComponents-2)]),
            (int)(255 * components[MIN(2,totalComponents-2)])];
}

@end
