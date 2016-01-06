//
//  UIColor+YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 16/1/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YYMessage)

/**
 *  Creates and returns a new color object whose brightness component is decreased by the given value, using the initial color values of the receiver.
 *
 *  @param value A floating point value describing the amount by which to decrease the brightness of the receiver.
 *
 *  @return A new color object whose brightness is decreased by the given values. The other color values remain the same as the receiver.
 */
- (UIColor *)colorByDarkeningColorWithValue:(CGFloat)value;
@end
