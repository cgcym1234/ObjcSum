//
//  YYMemoryCache.h
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 提供key-value pairs 存储,keys are retained and not copied
 所有的方法都是线程安全的,并使用了LRU-近期最少使用算法,移除pairs
 
 LRU 原理
 LRU（Least recently used，最近最少使用）算法根据数据的历史访问记录来进行淘汰数据，其核心思想是“如果数据最近被访问过，那么将来被访问的几率也更高”。
 
 实现如下：
 1. 新数据插入到链表头部；
 2. 每当缓存命中（即缓存数据被访问），则将数据移到链表头部；
 3. 当链表满的时候，将链表尾部的数据丢弃。
 
 【命中率】
 当存在热点数据时，LRU的效率很好，但偶发性的、周期性的批量操作会导致LRU命中率急剧下降，缓存污染情况比较严重。
 【复杂度】
 实现简单。
 【代价】
 命中时需要遍历链表，找到命中的数据块索引，然后需要将数据移到头部。
 
 YYMemoryCache is a fast in-memory cache that stores key-value pairs.
 In contrast to NSDictionary, keys are retained and not copied.
 The API and performance is similar to `NSCache`, all methods are thread-safe.
 
 YYMemoryCache objects differ from NSCache in a few ways:
 
 * It uses LRU (least-recently-used) to remove objects; NSCache's eviction method
 is non-deterministic.
 * It can be controlled by cost, count and age; NSCache's limits are imprecise.
 * It can be configured to automatically evict objects when receive memory
 warning or app enter background.
 
 The time of `Access Methods` in YYMemoryCache is typically in constant time (O(1)).
 */
@interface YYMemoryCache : NSObject

#pragma mark - Attribute

///=============================================================================
/// @name Attribute
///=============================================================================

/**名字 The name of the cache. Default is nil. */
@property (copy) NSString *name;

/**当前的key-value pairs数目 The number of objects in the cache (read-only) */
@property (readonly) NSUInteger totalCount;

/**当前的消耗 The total cost of objects in the cache (read-only). */
@property (readonly) NSUInteger totalCost;

#pragma mark - Limit

///=============================================================================
/// @name Limit
///=============================================================================

/**
 最多存放多少key-value pairs,默认无限
 The maximum number of objects the cache should hold.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 */
@property (assign) NSUInteger countLimit;

/**
 可以存储的value最大占用多少内存,默认无限
 The maximum total cost that the cache can hold before it starts evicting objects.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit—if the cache goes over the limit, some objects in the
 cache could be evicted later in backgound thread.
 */

@property (assign) NSUInteger costLimit;

/**
 缓存的过期时间,默认无限
 The maximum expiry time of objects in cache.
 
 @discussion The default value is DBL_MAX, which means no limit.
 This is not a strict limit—if an object goes over the limit, the object could
 be evicted later in backgound thread.
 */
@property (assign) NSTimeInterval ageLimit;

/**
 检查上面限制的周期,默认5秒,不符合的将被移除
 The auto trim check time interval in seconds. Default is 5.0.
 
 @discussion The cache holds an internal timer to check whether the cache reaches
 its limits, and if the limit is reached, it begins to evict objects.
 */
@property (assign) NSTimeInterval autoTrimInterval;

/**
 默认yes,收到内存告警时,将移除所有的内容
 If `YES`, the cache will remove all objects when the app receives a memory warning.
 The default value is `YES`.
 */
@property (assign) BOOL shouldRemoveAllObjectsOnMemoryWarning;

/**
 默认yes,当程序进入后台时,将移除所有的内容
 If `YES`, The cache will remove all objects when the app enter background.
 The default value is `YES`.
 */
@property (assign) BOOL shouldRemoveAllObjectsWhenEnteringBackground;

/**
 收到内存告警时,会执行这个block
 A block to be executed when the app receives a memory warning.
 The default value is nil.
 */
@property (copy) void(^didReceiveMemoryWarningBlock)(YYMemoryCache *cache);

/**
 当程序进入后台时,会执行这个block
 A block to be executed when the app enter background.
 The default value is nil.
 */
@property (copy) void(^didEnterBackgroundBlock)(YYMemoryCache *cache);

/**
 是否在主线程上释放key-value pair,默认NO,
 If `YES`, the key-value pair will be released on main thread, otherwise on
 background thread. Default is NO.
 
 @discussion You may set this value to `YES` if the key-value object contains
 the instance which should be released in main thread (such as UIView/CALayer).
 */
@property (assign) BOOL releaseOnMainThread;

/**
 是否异步释放key-value pair,默认yes,
 If `YES`, the key-value pair will be released asynchronously to avoid blocking
 the access methods, otherwise it will be released in the access method
 (such as removeObjectForKey:). Default is YES.
 */
@property (assign) BOOL releaseAsynchronously;

#pragma mark - Access Methods

///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 Returns a Boolean value that indicates whether a given key is in cache.
 
 @param key An object identifying the value. If nil, just return `NO`.
 @return Whether the key is in cache.
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 Returns the value associated with a given key.
 
 @param key An object identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (id)objectForKey:(id)key;

/**
 Sets the value of the specified key in the cache (0 cost).
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(id)object forKey:(id)key;

/**
 Sets the value of the specified key in the cache, and associates the key-value
 pair with the specified cost.
 
 @param object The object to store in the cache. If nil, it calls `removeObjectForKey`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @param cost   The cost with which to associate the key-value pair.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost;

/**
 Removes the value of the specified key in the cache.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(id)key;

/**
 Empties the cache immediately.
 */
- (void)removeAllObjects;


#pragma mark - Trim

///=============================================================================
/// @name Trim
///=============================================================================

/**
 使用LRU算法移除缓存的内容,直到totalCount小于或等于count
 Removes objects from the cache with LRU, until the `totalCount` is below or equal to
 the specified value.
 @param count  The total count allowed to remain after the cache has been trimmed.
 */
- (void)trimToCount:(NSUInteger)count;

/**
 类似上面
 Removes objects from the cache with LRU, until the `totalCost` is or equal to
 the specified value.
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 Removes objects from the cache with LRU, until all expiry objects removed by the
 specified value.
 @param age  The maximum age (in seconds) of objects.
 */
- (void)trimToAge:(NSTimeInterval)age;

@end




























