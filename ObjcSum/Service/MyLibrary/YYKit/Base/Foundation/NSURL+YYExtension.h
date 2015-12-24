//
//  NSURL+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/14.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (YYExtension)

/**
 *  将url的请求参数转换成字典,没有的话返回nil
 */
- (NSDictionary *)yy_dictionaryFromParameters;

@end
