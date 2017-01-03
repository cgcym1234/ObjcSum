//
//  NSString+YYSDK.h
//  ObjcSum
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (YYSDK)

/* 
 return @" " 
 */
+ (NSString *)blank;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/* Trims white space and new line characters, returns a new string */
- (NSString *)trimmed;

- (NSString *)toUnicodeString;
- (NSString *)toUnUnicodeString;

/* 行间距相关 */
-(CGSize)sizeWithFont:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;
@end
