//
//  UIButton+setBackgroundColorForState.m
//  JuMei
//
//  Created by cheng liu on 4/1/15.
//  Copyright (c) 2015 Jumei Inc. All rights reserved.
//

#import "UIButton+setBackgroundColorForState.h"

@implementation UIButton (setBackgroundColorForState)


- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, [UIScreen mainScreen].scale);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 3, 3)];
    [_backgroundColor setFill];
    [p fill];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forState:_state];
}

@end
