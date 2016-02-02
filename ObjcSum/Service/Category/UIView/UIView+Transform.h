//
//  UIView+Transform.h
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

// e.g. NSLog(@"Xscale: %f YScale: %f Rotation: %f", self.xscale, self.yscale, self.rotation * (180 / M_PI));
@interface UIView (Transform)

@property (readonly) CGFloat rotation;
@property (readonly) CGFloat scaleX;
@property (readonly) CGFloat scaleY;

@end
