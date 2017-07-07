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


- (NSNumber *)toFormattedNumber {
    float num = self.doubleValue;
    if (num == 0) {
        return @(0);
    }
    
    NSNumberFormatter *ft = [NSNumberFormatter new];
    ft.numberStyle = NSNumberFormatterDecimalStyle;
    ft.formatterBehavior = NSDateFormatterBehavior10_4;
    return [ft numberFromString:self] ?: @(num);
}


- (NSString *)toChineseUppercase {
    double numberals=[self doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix = [NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar  objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        NSInteger flag = valstr.length - 2;
        NSString *head=[valstr substringToIndex:flag - 1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        
        if (prefix.length > 0) {
            prefix =[prefix stringByAppendingString:@"元"];
        }
        
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            //            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            
            NSString *jiao = [numberchar objectAtIndex:[headch intValue]];
            NSString *fen = [numberchar objectAtIndex:[footch intValue]];
            
            if (headch.intValue != 0) {
                suffix = [NSString stringWithFormat:@"%@角", jiao];
            }
            
            if (footch.intValue != 0) {
                suffix = [NSString stringWithFormat:@"%@%@分", suffix, fen];
            }
        }
    }
    return [prefix stringByAppendingString:suffix];
}

@end

















