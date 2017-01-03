//
//  YYRightImageButton.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYRightImageButton;

typedef void(^YYRightImageButtonDidClickBlock)(YYRightImageButton *button);

/*
 1. lable在左边，图片在右边的view，
 2. 设置text后可使用intrinsicContentSize手动获得合适的大小，使用sizeToFit会自动调整为合适大小
 3. 可以在xib中使用autolayout，像label那样只设位置的约束即可，大小会自动计算
 4. 如果手动设置self的frame或bounds的宽度小于了自动计算的宽度，会将label宽度减小，出现xxx...
 */
@interface YYRightImageButton : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) IBInspectable UIImage *backgroundImage;
@property (nonatomic, strong) IBInspectable UIImage *image;

//默认14，黑色
@property (nonatomic, strong) IBInspectable UIFont *textLabelFont;
@property (nonatomic, strong) IBInspectable UIColor *textLabelColor;
@property (nonatomic, copy) IBInspectable NSString *text;

/*
 自定义图片大小，默认是CGSizeZero
 如果是CGSizeZero，则会根据图片内容自动适配大小
 */
@property (nonatomic, assign) IBInspectable CGSize imageSize;
@property (nonatomic, assign) IBInspectable UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) IBInspectable CGFloat spacing;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

@property (nonatomic, copy) YYRightImageButtonDidClickBlock didClickBlock;

@end
