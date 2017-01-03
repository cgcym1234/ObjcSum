//
//  NSString+YYSDK.m
//  ObjcSum
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSString+YYSDK.h"

@implementation NSString (YYSDK)

/* return @" " */
+ (NSString *)blank {
    return @" ";
}

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

/* Trims white space and new line characters, returns a new string */
- (NSString *)trimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)toUnicodeString {
    return [NSString stringWithCString:[self cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
}
- (NSString *)toUnUnicodeString {
    return [NSString stringWithCString:[self cStringUsingEncoding:NSNonLossyASCIIStringEncoding] encoding:NSUTF8StringEncoding];
}


/* 行间距相关 */
-(CGSize)sizeWithFont:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    if (!font) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paraStyle = [self paragraphWithLineSpacing:lineSpacing];
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont*)font lineSpacing:(CGFloat)lineSpacing {
    if (!font) {
        return nil;
    }
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:[self paragraphWithLineSpacing:lineSpacing]};
    
    /*
     //设置字间距 NSKernAttributeName:@1.5f
     NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
     };
     */
    
    return [[NSMutableAttributedString alloc] initWithString:self attributes:dic];
}

- (NSMutableParagraphStyle *)paragraphWithLineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    return paraStyle;
}
@end

















