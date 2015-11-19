//
//  HeaderColor.h
//  MyFrame
//
//  Created by sihuan on 15/6/4.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef MyFrame_HeaderColor_h
#define MyFrame_HeaderColor_h

#pragma mark - 颜色相关


#pragma mark - 从RGB取颜色

//直接从RGB取颜色16进制(RGB 0xFF00FF)
#define ColorFromRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorFromRGB(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorFromRGBA(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 随机色
#define ColorRandom [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define ColorSystem         ColorFromRGBHex(0x007aff)
#define ColorFlattingBlue   ColorFromRGBHex(0x27a7e0)
#define ColorSeparator   ColorFromRGBHex(0xc7c7c7)

#endif
