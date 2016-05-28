//
//  UIImage+Extension.h
//  MLLCustomer
//
//  Created by sihuan on 15/4/27.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

#pragma mark - 图片缩放到指定大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSquare:(CGFloat)witdh;

#pragma mark - 图片转换为NSData
- (NSData *)asNSData;

#pragma mark - 存储图像
- (BOOL)saveToDocumentWithName:(NSString *)imageName;

#pragma mark - 根据图片名返回image对象，如果没有，使用placeHolder
+ (UIImage *)getImageWithName:(NSString *)imageName placeHolder:(NSString *)placeHolderName;

#pragma mark - 修改图片着色
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

#pragma mark - UIColor和UIImage转换
+ (UIImage*)createImageWithColor:(UIColor*) color;

#pragma mark - 给view截图
+ (UIImage *)screenShotForView:(UIView *)view;
@end
