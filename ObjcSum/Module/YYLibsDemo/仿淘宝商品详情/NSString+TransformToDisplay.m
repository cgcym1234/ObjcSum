//
//  NSString+TransformToDisplay.m
//  MallData
//
//  Created by Lei Wu on 14-6-30.
//  Copyright (c) 2014年 jumei.com. All rights reserved.
//

#import "NSString+TransformToDisplay.h"

@implementation NSString (TransformToDisplay)

+ (NSString *)transformToMoneyDisplayFormatFromFloatValue:(float)money {
    return [NSString stringWithFormat:@"¥%@",
            [NSString transformToMoneyFormatFromFloatValue:money]];
}

+ (NSString *)transformToMoneyFormatFromFloatValue:(float)money {
    NSString *moneyStr_ = [NSString stringWithFormat:@"%.2f",money];
    return moneyStr_;
}

- (NSString *)transformToMoneyDisplayFormat {
    return [NSString stringWithFormat:@"¥%@",[self transformToMoneyFormat]];
}
- (NSString *)origPriceDisplayWithoutMoney {
    if (!self) {
        return @"";
    }
    
    if ([self isEqual:[NSNull null]]) {
        return @"";
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([self isEqualToString:@"-1"]) {
        return @"";
    }
    
    if (self.length == 0) {
        return @"";
    }
    
    return self;
    
}
- (NSString *)origPriceDisplay {
    if (!self) {
        return @"";
    }
    
    if ([self isEqual:[NSNull null]]) {
        return @"";
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([self isEqualToString:@"-1"]) {
        return @"";
    }
    
    if (self.length == 0) {
        return @"";
    }
    
    return [self transformToMoneyDisplayFormat];
    
}
- (NSString *)discountDisplay {
    if (!self) {
        return @"";
    }
    
    if ([self isEqual:[NSNull null]]) {
        return @"";
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([self isEqualToString:@"-1"]) {
        return @"";
    }
    
    if (self.length == 0) {
        return @"";
    }
    
    return self ;
    
}
- (NSString *)transformToMoneyFormat {
    if (!self) {
        return @"0";
    }
    
    if ([self isEqual:[NSNull null]]) {
        return @"0";
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return @"0";
    }
    
    NSRange range = [self rangeOfString:@"."];
    NSInteger p = range.location;
    NSInteger strLength = self.length;
    if (p != NSNotFound) {
        if (p == 0) {
            return [NSString stringWithFormat:@"0%@",self];
        }
        if (p + 1 == strLength) {
            return [NSString stringWithFormat:@"%@0",self];
        }
        if (p < strLength - 3) {
            return [self substringToIndex:p + 3];
        }
        if ((p + 3 == strLength) && (strLength > 2)){
            
            NSString *str1_ = [self substringFromIndex:(self.length - 2)];
            if (str1_ && [str1_ isEqualToString:@"00"]) {
                return [NSString stringWithFormat:@"%@",[self substringToIndex:strLength - 3]];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%@",self];
}

- (NSString *)discountDisplayText {
    NSString *discount_ = [self discountDisplay];
    if (discount_.length > 0) {
        return [NSString stringWithFormat:@"%@折",discount_];
    }
    else {
        return @"";
    }
}

- (NSString *)priceDisplayText {
    
    if (!self) {
        return @"";
    }
    
    if ([self isEqual:[NSNull null]]) {
        return @"";
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([self isEqualToString:@"-1"]) {
        return @"";
    }
    
    if (self.length == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"¥%@",self];
}

@end
