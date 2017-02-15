//
//  NSString+JMCategory.h
//  JuMei
//
//  Created by yangyuan on 2016/11/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (JMCategory)

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


/* 删除线 */
- (NSAttributedString *)addStrikethrough;

/* 将123.11中 11的字体大小改为size */
- (NSAttributedString *)seperatingByDotThenSetSecondPartFontSize:(NSInteger)fontSize;

/* 行间距相关 */
-(CGSize)sizeWithFont:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;

- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

@end














