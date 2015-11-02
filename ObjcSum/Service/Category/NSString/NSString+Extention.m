//
//  NSString+Extention.m
//  MyFrame
//
//  Created by michael chen on 14-9-4.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "NSString+Extention.h"
#import <CommonCrypto/CommonDigest.h>
#import "SSKeychain.h"

@implementation NSString (Extention)

#pragma mark - NSString格式化成urlStr

- (NSString *)URLEncodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*();+$,%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}


#pragma mark - NSString转换成二维码
- (UIImage *)toQRCodeImageWithSize:(CGSize)size {
    //    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    //    ZXBitMatrix *result = [writer encode:self format:kBarcodeFormatQRCode width:size.width height:size.height error:nil];
    //
    //    UIImage *resultImage = nil;
    //    if (result) {
    //        ZXImage *image = [ZXImage imageWithMatrix:result];
    //        resultImage = [UIImage imageWithCGImage:image.cgimage];
    //    }
    //    return resultImage;
    
//    return [QRCodeGenerator qrImageForString:self imageSize:size.width];
    return [UIImage new];
}

#pragma mark - NSString转换成二维坐标，格式@"123,456"
- (CLLocationCoordinate2D)toCoordinate2DWithSep:(NSString *)sep {
    NSArray *arrLocation = [self componentsSeparatedByString:@","];
    if (!arrLocation || arrLocation.count != 2) {
        return kCLLocationCoordinate2DInvalid;
    }
    return CLLocationCoordinate2DMake([arrLocation[0] doubleValue], [arrLocation[1] doubleValue]);
}


#pragma mark - NSString 转换成 md5
- (NSString *)stringToMD5
{
    if(!self || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

#pragma mark - 通过UUID生成唯一标志符
+ (NSString *)uniqueDeviceIdentifier
{
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",[self uniqueGlobalDeviceIdentifier],[NSBundle mainBundle].bundleIdentifier];
    return [stringToHash stringToMD5];
}

+ (NSString *)uniqueGlobalDeviceIdentifier
{
    static NSString *account = @"yy-device-id";
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *identifier = [SSKeychain passwordForService:bundleIdentifier
                                                  account:account];
    
    if (!identifier)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        identifier = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        CFRelease(uuidRef);
        
        [SSKeychain setPassword:identifier
                     forService:bundleIdentifier
                        account:account];
    }
    
    return [identifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


#pragma mark - 过滤掉emoji表情
- (NSString *)stringToDisableEmoji
{
    if (self.length <= 0) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark - 截取字符串，防止表情字符被中间截断
- (NSString *)truncateToLength:(NSInteger)maxLength {
    NSData *data = [self dataUsingEncoding:NSUTF32StringEncoding];
    NSUInteger length = data.length/4;
    if(length > maxLength ){
        data = [data subdataWithRange:NSMakeRange(0, maxLength * 4)];
        NSString *newStr = [[NSString alloc] initWithData:data encoding:NSUTF32StringEncoding];
        return newStr;
    }
    return self;
}

@end
