//
//  UIImage+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIImage+YYMessage.h"
#import "NSString+YYMessage.h"
#import "NSDate+YYMessage.h"
#import "YYMessageCellLayoutConfig.h"

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

+ (CGSize)sizeProperlyFromOrigin:(CGSize)originSize
                             min:(CGSize)imageMinSize
                             max:(CGSize)imageMaxSiz {
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width, imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

#pragma mark - 获取Image

+ (UIImage *)imageByNameOrPath:(NSString *)imageNameOrPath {
    UIImage *image = [UIImage imageNamed:imageNameOrPath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imageNameOrPath];
    }
    return image;
}

- (NSString *)saveToDiskAsThumbnail {
    return [self saveToDiskWithSize:[UIImage sizeProperlyFromOrigin:self.size min:[YYMessageCellConfig defaultConfig].attachmentImageSizeMin max:[YYMessageCellConfig defaultConfig].attachmentImageSizeMax]];
}

- (NSString *)saveToDiskWithSize:(CGSize)targetSize {
    UIImage *targetSizeImage = [self imageByResizeToSize:targetSize];
    if (targetSizeImage) {
        NSString *fullPath = [NSString fullPathOfImageByCurrentTimestamp];
        
        NSError *error;
        [UIImagePNGRepresentation(targetSizeImage) writeToFile:fullPath options:NSDataWritingAtomic error:&error];
        if (!error) {
            return fullPath;
        }
        return nil;
    }
     return nil;
}

- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
