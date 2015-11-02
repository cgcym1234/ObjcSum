//
//  NSObject+Extention.h
//  KKouNew
//
//  Created by huansi on 14-8-27.
//  Copyright (c) 2014年 KKOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extention)

#pragma mark - 将object转化成NSString
- (NSString *)toString;


#pragma mark - 创建一个自己的拷贝
/**
 *  简单版
 使用注意：
 1.只对类本身的property复制（忽略父类属性）
 2.类中的一个属性是其他的类（组合），那么值nil（没做拷贝）
 */
- (id)getCopyOfSelf;

#pragma mark - 获取属性列表
- (NSArray *)getPropertyList;
- (NSArray *)getPropertyList: (Class)clazz;


#pragma mark - 根据类名来实例化对象,
+ (id)instanceFromString:(NSString *)clsName;
@end
