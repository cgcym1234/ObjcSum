//
//  UIImage+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIImage+YYMessage.h"

@implementation UIImage (YYMessage)

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor {
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)bubbleRegularImage {
    return [UIImage imageNamed:@"bubble_regular_downward"];
}
+ (UIImage *)bubbleStrokedImage {
    return [UIImage imageNamed:@"bubble_stroked_downward"];
}

/**
 *  @return 水平翻转后的图片
 */
- (UIImage *)imageHorizontallyFlipped {
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
}

/**
 *  @return 拉伸后的图片
 */
- (UIImage *)imageStretchabledWithCapInsets:(UIEdgeInsets)capInsets {
    return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

/**
 *  @return 中心点拉伸后的图片
 */
- (UIImage *)imageStretchabledFromCenterPointEdgeInsets {
    return [self imageStretchabledWithCapInsets:[self centerPointEdgeInsetsForImage]];
}

/**
 *  make image stretchable from center point
 */
- (UIEdgeInsets)centerPointEdgeInsetsForImage {
    CGPoint center = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f);
    return UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
}
@end
