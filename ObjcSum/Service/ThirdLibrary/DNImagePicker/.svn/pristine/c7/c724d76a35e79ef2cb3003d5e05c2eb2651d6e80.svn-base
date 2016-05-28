//
//  UIImage+Extension.m
//  MLLCustomer
//
//  Created by sihuan on 15/4/27.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

- (UIImage *)imageByScalingToSquare:(CGFloat)witdh {
    return [self imageByScalingToSize:CGSizeMake(witdh, witdh)];
}

- (NSData *)asNSData {
    return UIImagePNGRepresentation(self);
}

- (BOOL)saveToDocumentWithName:(NSString *)imageName {
    if (!imageName) {
        return NO;
    }
    NSData *imageData = UIImagePNGRepresentation(self);
    if (!imageData) {
        return NO;
    }
    
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fullPath = [documentDir stringByAppendingPathComponent:imageName];
    
    return [imageData writeToFile:fullPath atomically:YES];
}

#pragma mark - 根据图片名返回image对象，如果没有，使用placeHolder
+ (UIImage *)getImageWithName:(NSString *)imageName placeHolder:(NSString *)placeHolderName {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fullPath = [documentDir stringByAppendingPathComponent:imageName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        return [UIImage imageNamed:placeHolderName];
    }
    
    return [UIImage imageWithContentsOfFile:fullPath];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)screenShotForView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
