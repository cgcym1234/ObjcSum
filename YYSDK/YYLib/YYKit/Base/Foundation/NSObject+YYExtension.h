//
//  NSObject+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  提供方法交换,属性添加,注册KVO等便捷方法
 */
@interface NSObject (YYExtension)

#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)yy_swizzleInstanceMethod:(SEL)originalSel withNew:(SEL)newSel;

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)yy_swizzleClassMethod:(SEL)originalSel withNew:(SEL)newSel;

#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================


/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)yy_setAssociateValue:(id)value withKey:(void *)key;

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)yy_setAssociateWeakValue:(id)value withKey:(void *)key;

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (id)yy_getAssociatedValueForKey:(void *)key;

/**
 Remove all associated values.
 */
- (void)yy_removeAssociatedValues;

#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Returns the class name in NSString.
 */
+ (NSString *)yy_className;

/**
 Returns the class name in NSString.
 
 @discussion Apple has implemented this method in NSObject(NSLayoutConstraintCallsThis),
 but did not make it public.
 */
- (NSString *)yy_className;

/**
 Returns a copy of the instance with `NSKeyedArchiver` and ``NSKeyedUnarchiver``.
 Returns nil if an error occurs.
 */
- (id)yy_deepCopy;

/**
 Returns a copy of the instance use archiver and unarchiver.
 Returns nil if an error occurs.
 
 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (id)yy_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

/**
 *  通过运行时机制取得对象的属性(property)，并存入到数组中
 */
- (NSArray *)yy_arrayWithProperties;
+ (NSArray *)yy_arrayWithPropertiesFromClass:(Class)clazz;

/**
 *  把一个实体对象，封装成字典Dictionary,只支持简单类型
 key为property名字,value为该property的取值
 */
- (NSDictionary *)yy_dictionaryWithProperties;

/**
 *  根据类名来实例化对象
 */
+ (id)yy_instanceFromClassName:(NSString *)clsName;

#pragma mark - KVO

/**
 Registers a block to receive KVO notifications for the specified key-path
 relative to the receiver.
 
 @discussion The block and block captured objects are retained. Call
 `removeObserverBlocksForKeyPath:` or `removeObserverBlocks` to release.
 
 @param keyPath The key path, relative to the receiver, of the property to
 observe. This value must not be nil.
 
 @param block   The block to register for KVO notifications.
 */
- (void)yy_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications for the property specified by a given key-path
 relative to the receiver, and release these blocks.
 
 @param keyPath A key-path, relative to the receiver, for which blocks is
 registered to receive KVO change notifications.
 */
- (void)yy_removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications, and release these blocks.
 */
- (void)yy_removeObserverBlocks;

@end












