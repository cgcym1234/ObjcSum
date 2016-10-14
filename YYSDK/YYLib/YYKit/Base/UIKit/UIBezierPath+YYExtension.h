//
//  UIBezierPath+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/15.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (YYExtension)

/**
 Creates and returns a new UIBezierPath object initialized with the text glyphs
 generated from the specified font.
 
 @discussion It doesnot support apple emoji. If you want get emoji image, try
 [UIImage imageWithEmoji:size:] in `UIImage(YYAdd)`.
 
 @param text The text to generate glyph path.
 @param font The font to generate glyph path.
 
 @return A new path object with the text and font, or nil if an error occurs.
 */
+ (UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end
