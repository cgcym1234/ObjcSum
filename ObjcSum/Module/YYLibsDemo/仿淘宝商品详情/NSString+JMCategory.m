//
//  NSString+JMCategory.m
//  JuMei
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "NSString+JMCategory.h"

@implementation NSString (JMCategory)

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


/* 删除线 */
- (NSAttributedString *)addStrikethrough {
    if (!self.isNotBlank) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString:self attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
}

//将123.11中 11的字体大小改为size
- (NSAttributedString *)seperatingByDotThenSetSecondPartFontSize:(NSInteger)fontSize {
    if (!self.isNotBlank) {
        return nil;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:@"."];
    if (range.location == NSNotFound) {
        return attrStr;
    }
    
    range.location += 1;
    range.length = self.length - range.location;
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    return attrStr;
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

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self yy_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self yy_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)yy_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    if (!font) {
        font = [UIFont systemFontOfSize:12];
    }
    
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    
    return rect.size;
}

@end















