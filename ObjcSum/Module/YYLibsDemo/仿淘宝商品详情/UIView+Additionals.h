//
//  UIView+Additionals.h
//  JuMei
//
//  Created by Jinxiao on 8/13/14.
//  Copyright (c) 2014 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ParentChain)

- (UIViewController *)avaliableViewController;

@end

@interface UIView (Properties)


//view + frame
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

- (CGFloat) frameMatch:(CGFloat) source;

- (CGRect) fixFrame:(CGRect)frame standardWidth:(CGFloat) width;

@end
