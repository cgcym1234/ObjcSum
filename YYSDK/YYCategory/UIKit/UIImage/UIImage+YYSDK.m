//
//  UIImage+Extension.m
//  SinaWeibo
//
//  Created by huansi on 14-8-6.
//  Copyright (c) 2014年 huansi. All rights reserved.
//

#import "UIImage+YYSDK.h"

@implementation UIImage (YYSDK)

+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *newName = name;
//    if (IOS7) {
//        //newName = [name stringByAppendingString:@"_os7"];
//    }
    
    return [UIImage imageNamed:newName];
}

/**
 *  根据图片名返回一张能自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

#pragma mark - 图片缩放到指定大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(targetSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageByScalingToSquare:(CGFloat)witdh {
    return [self imageByScalingToSize:CGSizeMake(witdh, witdh)];
}

#pragma mark - 图片等比例缩放到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 图片转换为NSData
- (NSData *)asNSData {
    return UIImagePNGRepresentation(self);
}

#pragma mark - 存储图像
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

#pragma mark - 修改图片着色
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

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(2, 44)];
}

+ (UIImage*)imageWithColor: (UIColor*) color size:(CGSize)size
{
    CGRect rect = {CGPointZero, size};
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 给view截图
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

- (CGSize)fitSizeInView:(UIView *)toView {
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    BOOL overWidth = imageWidth > toView.bounds.size.width;
    BOOL overHeight = imageHeight > toView.bounds.size.height;
    
    CGSize fitSize = CGSizeMake(imageWidth, imageHeight);
    
    if (overWidth && overHeight) {
        CGFloat timesThanScreenWidth = (imageWidth / toView.bounds.size.width);
        
        if (!((imageHeight / timesThanScreenWidth) > toView.bounds.size.height)) {
            fitSize.width = toView.bounds.size.width;
            fitSize.height = imageHeight / timesThanScreenWidth;
        } else {
            CGFloat timesThanScreenHeight = (imageHeight / toView.bounds.size.height);
            fitSize.width = imageWidth / timesThanScreenHeight;
            fitSize.height = toView.bounds.size.height;
        }
    } else if (overWidth && !overHeight) {
        CGFloat timesThanFrameWidth = (imageWidth / toView.bounds.size.width);
        fitSize.width = toView.bounds.size.width;
        fitSize.height = imageHeight / timesThanFrameWidth;
    } else if (overHeight && !overWidth) {
        fitSize.height = toView.bounds.size.height;
    }
    
    return fitSize;
}

@end
