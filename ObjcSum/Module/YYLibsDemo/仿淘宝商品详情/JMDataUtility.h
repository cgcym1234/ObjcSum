//
//  JMDataUtility.h
//  jmsdk
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 sunxiao. All rights reserved.
//
#import <Foundation/Foundation.h>
////////////////////////////////////////////////////////////////////////////////////////////////////
// 安全取得对象的方法，不用再作Check
////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 *  @brief 不知道是什么对象，转为NSString
 *
 *  @param object 对象
 *
 *  @return string
 */
NSString *stringWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSNumber
 *
 *  @param object 对象
 *
 *  @return number
 */
NSNumber *numberWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSDictionary
 *
 *  @param object 对象
 *
 *  @return dictionary
 */
NSDictionary *dictionaryWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSArray
 *
 *  @param object 对象
 *
 *  @return array
 */
NSArray *arrayWithObject(id object);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return id
 */
id objectInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 * 不知道是否为NSArray对象，是否越界，取得对应Index的对象
 */
/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应Index的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return id
 */
id objectInArrayAtIndex(NSArray *array, NSUInteger index);

/**
 * 不知道是否为NSArray对象，是否越界，取得对应NSString的对象
 */
/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSString的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return string
 */
NSString *stringInArrayAtIndex(NSArray *array, NSUInteger index);


/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSNumber的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return number
 */
NSNumber *numberInArrayAtIndex(NSArray *array, NSUInteger index);

/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSDictionary的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return dictionary
 */
NSDictionary *dictionaryInArrayAtIndex(NSArray *array, NSUInteger index);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSString
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return string
 */
NSString *stringInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 * 不知道是否为NSDictionary对象，取得对应Key的Value NSNumber
 */
/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSNumber
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return number
 */
NSNumber *numberInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSArray
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return array
 */
NSArray *arrayInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSArray
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return dictionary
 */
NSDictionary *dictionaryInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

