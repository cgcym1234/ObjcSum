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
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",[self uniqueUUID],[NSBundle mainBundle].bundleIdentifier];
    return [stringToHash stringToMD5];
}

+ (NSString *)uniqueUUID {
    static NSString *account = @"yy-device-id";
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *identifier = [SSKeychain passwordForService:bundleIdentifier
                                                  account:account];
    
    if (!identifier) {
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:identifier
                     forService:bundleIdentifier
                        account:account];
    }
    
    return identifier;
//    return [identifier stringByReplacingOccurrencesOfString:@"-" withString:@""];
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

#pragma mark - 将阿拉伯数字转换为中文数字
+ (NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

#pragma mark - 一些校验
//是纯数字
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

////完全没有数字
//- (BOOL)hasNoInt:(NSString *)string
//{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    int val;
//    return [scan scanInt:&val] && [scan scanLocation] == 0;
//}

- (BOOL)isPureLetters {
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (BOOL)hasAtLeastOneNumber {
    NSRegularExpression *exp = [[NSRegularExpression alloc] initWithPattern:@"(.*?)\\d+(.*?)" options:NSRegularExpressionCaseInsensitive error:nil];
    return [exp numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (BOOL)isPureSymbol {
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:@"^\\S[^A-Z^a-z^0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (BOOL)isValidatePassword
{
    if (self.length < 6 || self.length > 20 || [self isPureInt] || [self isPureLetters] || [self isPureSymbol]  ) {
        return NO;
    }
    return YES;
}

- (BOOL)isValidate400PhoneNumber {
    if ([self isPureInt] && [self hasPrefix:@"400"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isContainSerialCharacters{
    
    NSString *regx = @"^.*(.)\\1{2}.*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    return [predicate evaluateWithObject:self];
}

-(BOOL)isValidateMobilePhoneNumber
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";;
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //虚拟运营商专属号段
    NSString *new = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}|(1700)\\d{7}$";;
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestnew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", new];
    
    if (([regextestmobile evaluateWithObject:self])
        || ([regextestcm evaluateWithObject:self])
        || ([regextestct evaluateWithObject:self])
        || ([regextestcu evaluateWithObject:self])
        || ([regextestnew evaluateWithObject:self]))
    {
        return YES;
    }
    else
    {
        if ([self isValidate400PhoneNumber]) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)isValidEmail{
    //   NSString *emailRegular =@"[/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/]";
    NSString *emailRegular =@"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegular];
    if ([predicate evaluateWithObject:self] ) {
        return YES;
    }
    return NO;
}

@end
