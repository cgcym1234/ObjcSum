//
//  YYFoundation.h
//  MySimpleFrame
//
//  Created by sihuan on 15/5/12.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYFoundation : NSObject

#pragma mark - 判断是否NSString、NSNumber，NSDictionary等基本数据
+ (BOOL)isClassFromFoundation:(Class)c;

@end
