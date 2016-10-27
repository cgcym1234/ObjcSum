//
//  YYRightImageButton.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYRightImageButton : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) IBInspectable UIImage *backgroundImage;
@property (nonatomic, strong) IBInspectable UIImage *image;

@property (nonatomic, strong) IBInspectable UIFont *textLabelFont;
@property (nonatomic, strong) IBInspectable UIColor *textLabelColor;
@property (nonatomic, copy) IBInspectable NSString *text;

@property (nonatomic, assign) IBInspectable CGSize imageSize;
@property (nonatomic, assign) IBInspectable UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) IBInspectable CGFloat spacing;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

@end
