//
//  UIImage+YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 16/1/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYMessage)

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;

/**
 *  @return The regular message bubble image.
 */
+ (UIImage *)bubbleRegularImage;

/**
 *  @return The regular message bubble image stroked, not filled.
 */
+ (UIImage *)bubbleStrokedImage;

/**
 *  @return 水平翻转后的图片
 */
- (UIImage *)imageHorizontallyFlipped;

/**
 *  @return 拉伸后的图片
 */
- (UIImage *)imageStretchabledWithCapInsets:(UIEdgeInsets)capInsets;

/**
 *  @return 中心点拉伸后的图片
 */
- (UIImage *)imageStretchabledFromCenterPointEdgeInsets;

/**
 *  make image stretchable from center point
 */
- (UIEdgeInsets)centerPointEdgeInsetsForImage;

+ (CGSize)sizeProperlyFromOrigin:(CGSize)originSize
                             min:(CGSize)imageMinSize
                             max:(CGSize)imageMaxSiz;
#pragma mark - 获取Image

+ (UIImage *)imageByNameOrPath:(NSString *)imageNameOrPath;

- (NSString *)saveToDiskAsThumbnail;
- (NSString *)saveToDiskWithSize:(CGSize)size;

- (UIImage *)imageByResizeToSize:(CGSize)size;

@end
