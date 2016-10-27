//
//  UIButton+YYSDK.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYButtonImagePosition) {
    YYButtonImagePositionLeft,//图片在左，文字在右
    YYButtonImagePositionRight,//图片在右，文字在左
    YYButtonImagePositionTop,//图片在上，文字在下
    YYButtonImagePositionBottom//图片在下，文字在上
};

@interface UIButton (YYSDK)

#pragma mark - 调整文字和图片位置
/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(YYButtonImagePosition)postion spacing:(CGFloat)spacing;

#pragma mark - Title

- (void)setTitleAll:(NSString *)title;
- (void)setTitleNormal:(NSString *)title;
- (void)setTitleHighlighted:(NSString *)title;
- (void)setTitleDisabled:(NSString *)title;
- (void)setTitleSelected:(NSString *)title;

- (NSString *)titleNomal;
- (NSString *)titleHighlighted;
- (NSString *)titleDisabled;
- (NSString *)titleSelected;

#pragma mark - 背景色

- (void)setBackgroundColorNomal:(UIColor *)color;
- (void)setBackgroundColorHighlighted:(UIColor *)color;
- (void)setBackgroundColorDisabled:(UIColor *)color;
- (void)setBackgroundColorSelected:(UIColor *)color;


@end





