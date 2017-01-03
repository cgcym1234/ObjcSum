//
//  NSObject+Utility.h
//  DGUtilityKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 *    @brief 对象是否为某种类型的对象，或是否可以转换到某种类型
 */
@interface NSObject (ValidObject)

- (NSString *)validString;
- (NSArray *)validArray;
- (NSDictionary *)validDictionary;
- (NSURL *)validURL;

@end

/**
 *    @brief 按照指定的类型来访问字典中的元素，
 如果字典中的元素不符合指定的类型，或无法转换到指定的类型，则返回nil，
 */
@interface NSDictionary (ValidObject)

- (NSNumber *)validNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)validNumberForKey:(NSString *)key;

- (NSString *)validStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSString *)validStringForKey:(NSString *)key;

- (NSArray *)validArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSArray *)validArrayForKey:(NSString *)key;

- (NSDictionary *)validDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (NSDictionary *)validDictionaryForKey:(NSString *)key;

@end

/**
 *    @brief 按照指定的类型来访问数组中的元素，
    如果数组中的元素不符合指定的类型，或无法转换到指定的类型，则返回nil，
 */
@interface NSArray (ValidObject)

- (NSNumber *)validNumberAtIndex:(NSInteger)index defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)validNumberAtIndex:(NSInteger)index;

- (NSString *)validStringAtIndex:(NSInteger)index defaultValue:(NSString *)defaultValue;
- (NSString *)validStringAtIndex:(NSInteger)index;

- (NSArray *)validArrayAtIndex:(NSInteger)index defaultValue:(NSArray *)defaultValue;
- (NSArray *)validArrayAtIndex:(NSInteger)index;

- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index defaultValue:(NSDictionary *)defaultValue;
- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index;

@end

@interface NSMutableDictionary (SafeObject)

/**
 *    @brief 添加一个对象到字典，无须检查对象是否为nil
 *
 *    @param object 要添加到字典中的对象
 *    @param key    对象对应的key值
 */
- (void)setSafeObject:(id)object forKey:(id<NSCopying>)key;

@end

@interface NSMutableArray (SafeObject)

/**
 *    @brief 添加一个对象到数组，无须检查对象是否为nil
 *
 *    @param object 要添加到数组中的对象
 */
- (void)addSafeObject:(id)object;

@end

@interface NSArray (SafeObject)

/**
 *    @brief 获取指定数组中的对象，不会引起索引越界的错误
 *
 *    @param index 索引值
 *
 *    @return 获取到的对象或nil
 */
- (id)safeObjectAtIndex:(NSInteger)index;

@end