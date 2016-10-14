//
//  NSError+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSError+YYExtension.h"

@implementation NSError (YYExtension)

/**
 *  快速生成一个error
 domain 是 NSLocalizedDescriptionKey
 code 是 self.code
 message 是 self.localizedDescription
 
 userInfo:@{NSLocalizedDescriptionKey :message}
 */
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:NSCocoaErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey :message}];
}

@end
