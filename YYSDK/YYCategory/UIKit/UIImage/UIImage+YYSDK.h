//
//  UIImage+Extension.h
//  SinaWeibo
//
//  Created by huansi on 14-8-6.
//  Copyright (c) 2014年 huansi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYSDK)

#pragma mark - Image Info

/**
 Whether this image has alpha channel.
 */
- (BOOL)hasAlphaChannel;

/**
 *根据图片名自动加载适配IOS6和iOS7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能自由拉伸的图片
 *  以长度的一半，高度的一半为中心进行拉伸。
 */
+ (UIImage *)resizedImage:(NSString *)name;

#pragma mark - 图片缩放到指定大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSquare:(CGFloat)witdh;

#pragma mark - 图片等比例缩放到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

#pragma mark - 图片转换为NSData
- (NSData *)asNSData;

#pragma mark - 存储图像
- (BOOL)saveToDocumentWithName:(NSString *)imageName;

#pragma mark - 根据图片名返回image对象，如果没有，使用placeHolder
+ (UIImage *)getImageWithName:(NSString *)imageName placeHolder:(NSString *)placeHolderName;

#pragma mark - 修改图片着色
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

#pragma mark - UIColor和UIImage转换

+ (UIImage*)imageWithColor:(UIColor*) color;
+ (UIImage*)imageWithColor:(UIColor*) color size:(CGSize)size;

#pragma mark - 给view截图
+ (UIImage *)screenShotForView:(UIView *)view;

- (CGSize)fitSizeInView:(UIView *)toView;

@end
