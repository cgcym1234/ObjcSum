//
//  YYDiskCache.m
//  ObjcSum
//
//  Created by sihuan on 15/12/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYDiskCache.h"

#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import <time.h>

@implementation YYDiskCache

#pragma mark - public

#pragma mark - Initializer

///=============================================================================
/// @name Initializer
///=============================================================================

- (instancetype)init UNAVAILABLE_ATTRIBUTE {
    @throw [NSException exceptionWithName:@"YYDiskCache init error" reason:@"YYDiskCache must be initialized with a path. Use 'initWithPath:' or 'initWithPath:inlineThreshold:' instead." userInfo:nil];
    return [self initWithPath:nil inlineThreshold:0];

}

/**
 Create a new cache based on the specified path.
 
 @param path Full path of a directory in which the cache will write data.
 Once initialized you should not read and write to this directory.
 
 @return A new cache object, or nil if an error occurs.
 
 @warning Multiple instances with the same path will make the storage unstable.
 */
- (instancetype)initWithPath:(NSString *)path {
    return [self initWithPath:path inlineThreshold:1024 * 20]; // 20KB
}

/**
 The designated initializer.
 
 @param path       Full path of a directory in which the cache will write data.
 Once initialized you should not read and write to this directory.
 
 @param threshold  The data store inline threshold in bytes. If the object's data
 size (in bytes) is larger than this value, then object will be stored as a
 file, otherwise the object will be stored in sqlite. 0 means all objects will
 be stored as separated files, NSUIntegerMax means all objects will be stored
 in sqlite. If you don't know your object's size, 20480 is a good choice.
 After first initialized you should not change this value of the specified path.
 
 @return A new cache object, or nil if an error occurs.
 
 @warning Multiple instances with the same path will make the storage unstable.
 */
- (instancetype)initWithPath:(NSString *)path
             inlineThreshold:(NSUInteger)threshold {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Access Methods

///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns a boolean value that indicates whether a given key is in cache.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return NO.
 @return Whether the key is in cache.
 */
- (BOOL)containsObjectForKey:(NSString *)key {
    return YES;
}

/**
 Returns a boolean value with the block that indicates whether a given key is in cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key   A string identifying the value. If nil, just return NO.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL contains))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the value associated with a given key.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (id<NSCoding>)objectForKey:(NSString *)key {
    return @(1);
}

/**
 Returns the value associated with a given key.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Sets the value of the specified key in the cache.
 This method may blocks the calling thread until file write finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    
}

/**
 Sets the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes the value of the specified key in the cache.
 This method may blocks the calling thread until file delete finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(NSString *)key {
    
}

/**
 Removes the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Empties the cache.
 This method may blocks the calling thread until file delete finished.
 */
- (void)removeAllObjects {
    
}

/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block {
    
}

/**
 不阻塞,带删除的进度
 Empties the cache with block.
 This method returns immediately and executes the clear operation with block in background.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end {
    
}


/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the number of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects count.
 */
- (NSInteger)totalCount {
    return 1;
}

/**
 Get the number of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the total cost (in bytes) of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects cost in bytes.
 */
- (NSInteger)totalCost {
    return 2;
}

/**
 Get the total cost (in bytes) of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block {
    
}


#pragma mark - Trim

///=============================================================================
/// @name Trim
///=============================================================================

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 */
- (void)trimToCount:(NSUInteger)count {
    
}

/**
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost {
    
}

/**
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block {
    
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param age  The maximum age of the object.
 */
- (void)trimToAge:(NSTimeInterval)age {
    
}

/**
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param age  The maximum age of the object.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block {
    
}


#pragma mark - Extended Data

///=============================================================================
/// @name Extended Data
///=============================================================================

/**
 Get extended data from an object.
 
 @discussion See 'setExtendedData:toObject:' for more information.
 
 @param object An object.
 @return The extended data.
 */
+ (NSData *)getExtendedDataFromObject:(id)object {
    return [NSData new];
}

/**
 在缓存对象被保存到磁盘缓存前,可以设置额外的数据给它.nil,表示删除
 Set extended data to an object.
 
 @discussion You can set any extended data to an object before you save the object
 to disk cache. The extended data will also be saved with this object. You can get
 the extended data later with "getExtendedDataFromObject:".
 
 @param extendedData The extended data (pass nil to remove).
 @param object       The object.
 */
+ (void)setExtendedData:(NSData *)extendedData toObject:(id)object {
    
}


@end
