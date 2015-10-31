//
//  EncryptionDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/19.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "EncryptionDemo.h"
#import "AESenAndDe.h"

@interface EncryptionDemo ()

@end

@implementation EncryptionDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str = @"zhangjianlong";
    NSString *encryptStr = [self stringFromAESEncrypt:str];
    NSLog(@"加密前: %@， 加密后: %@", str, encryptStr);
}


#define PrivateKey @"3b188cf6d320b798"

#pragma mark - AES/ECB/PKCS5Padding加密以后再 base64 转成字符串
- (NSString*)stringFromAESEncrypt:(NSString *)str{
    return [AESenAndDe En_AESandBase64EnToString:str privateKey:PrivateKey];
}

@end
