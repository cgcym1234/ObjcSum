//
//  YYQRcodeGenerater.h
//  ObjcSum
//
//  Created by sihuan on 15/11/17.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYQRcodeGenerater : NSObject

#pragma mark - 通过NSString生成二维码
+ (UIImage *)generateImageWithSize:(CGSize)size qrCodeStirng:(NSString *)qrCodeStirng;


@end
