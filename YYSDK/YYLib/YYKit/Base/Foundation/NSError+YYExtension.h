//
//  NSError+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (YYExtension)

/**
 *  NSError 便捷方法
 domain 是 NSCocoaErrorDomain
 code 是 self.code
 message 是 self.localizedDescription
 
 userInfo:@{NSLocalizedDescriptionKey :message}
 */
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;

@end
