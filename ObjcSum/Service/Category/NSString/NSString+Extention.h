//
//  NSString+Extention.h
//  MyFrame
//
//  Created by michael chen on 14-9-4.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NSString (Extention)

#pragma mark - NSString格式化成urlStr
-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;

#pragma mark - NSString转换成二维码
- (UIImage *)toQRCodeImageWithSize:(CGSize)size;

#pragma mark - NSString转换成二维坐标，格式@"123,456"
- (CLLocationCoordinate2D)toCoordinate2DWithSep:(NSString *)sep;

#pragma mark - NSString 转换成 md5
- (NSString *)stringToMD5;

#pragma mark - 通过UUID生成唯一标志符
+ (NSString *)uniqueDeviceIdentifier;

#pragma mark - 过滤掉emoji表情
- (NSString *)stringToDisableEmoji;

#pragma mark - 截取字符串，防止表情字符被中间截断
- (NSString *)truncateToLength:(NSInteger)maxLength;
@end
