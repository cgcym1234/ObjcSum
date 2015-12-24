//
//  NSURL+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/14.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSURL+YYExtension.h"
#import "NSString+YYExtension.h"


@implementation NSURL (YYExtension)

/**
 *  将url的请求参数转换成字典
 */
- (NSDictionary *)yy_dictionaryFromParameters {
    return [self.absoluteString yy_dictionaryFromUrlParameters];
}

@end
