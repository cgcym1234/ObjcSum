//
//  YYLabel.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

//指定padding,默认zero
@property (nonatomic, assign) IBInspectable UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) IBInspectable CGFloat insetTop;
@property (nonatomic, assign) IBInspectable CGFloat insetLeft;
@property (nonatomic, assign) IBInspectable CGFloat insetBottom;
@property (nonatomic, assign) IBInspectable CGFloat insetRight;

@end





