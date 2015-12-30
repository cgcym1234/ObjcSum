//
//  InterfaceAndAPI.h
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterfaceAndAPI : NSObject

#pragma mark - 18 尽量使用不可变对象

/**
 *  key，value，这2个属性不希望被外界直接修改，所以这里使用readonly
 */
@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSString *value;

/**
 *  这里的集合keys，对外公开的是不可变版本，内部使用NSMutableArray
 并提供了addKey和removeKey方法。
 */
@property (nonatomic, strong, readonly) NSArray *keys;
- (void)addKey:(NSString *)key;
- (void)removeKey:(NSString *)key;

- (instancetype)init;

#pragma mark - 第 16 条:提供"全能初始化方法"
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

@end
