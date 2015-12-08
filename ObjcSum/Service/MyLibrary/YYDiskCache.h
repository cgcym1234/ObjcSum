//
//  YYDiskCache.h
//  ObjcSum
//
//  Created by sihuan on 15/12/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 线程安全的key-value pairs磁盘缓存,使用SQLite和文件系统(类似 NSURLCache的磁盘缓存)
 实现了 LRU 淘汰算法、更快的数据统计，更多的容量控制选项。
 
 直接从官网下载最新的 SQLite 源码编译，会比 iOS 系统自带的 sqlite3.dylib 性能要高 2~4倍
 YYDiskCache is a thread-safe cache that stores key-value pairs backed by SQLite
 and file system (similar to NSURLCache's disk cache).
 
 YYDiskCache has these features:
 
 * It use LRU (least-recently-used) to remove objects.
 * It can be controlled by cost, count, and age.
 * It can be configured to automatically evict objects when there's no free disk space.
 * It can automatically decide the storage type (sqlite/file) for each object to get
 better performance.
 
 You may compile the lastest version of sqlite and ignore the libsqlite3.dylib in
 iOS system to get 2x~4x speed up.
 */
@interface YYDiskCache : NSObject

#pragma mark - Attribute

///=============================================================================
/// @name Attribute
///=============================================================================

/** The name of the cache. Default is nil. */
@property (copy) NSString *name;

/** The path of the cache (read-only). */
@property (readonly) NSString *path;

/**
 使用sqlite或文件存储的阈值,默认20KB

 SQLite 写入性能比直接写文件要高，但读取性能取决于数据大小：
 当单条数据小于 20K 时，数据越小 SQLite 读取性能越高；单条数据大于 20K 时，直接写为文件速度会更快一些。
 基于 SQLite 的这种表现，磁盘缓存最好是把 SQLite 和文件存储结合起来;value 数据根据大小不同选择 SQLite 或文件存储。
 
 If the object's data size (in bytes) is larger than this value, then object will
 be stored as a file, otherwise the object will be stored in sqlite.
 
 0 means all objects will be stored as separated files, NSUIntegerMax means all
 objects will be stored in sqlite.
 
 The default value is 20480 (20KB).
 */
@property (readonly) NSUInteger inlineThreshold;

/**
 默认使用NSKeyedArchiver归档,可以自定义替换之
 
 If this block in not nil, then the block will be used to archive object instead
 of NSKeyedArchiver. You can use this block to support the objects which do not
 conform to the `NSCoding` protocol.
 
 The default value is nil.
 */

@property (copy) NSData *(^customArchiveBlock)(id object);

/**
 If this block in not nil, then the block will be used to unarchive object instead
 of NSKeyedUnarchiver. You can use this block to support the objects which do not
 conform to the `NSCoding` protocol.
 
 The default value is nil.
 */
@property (copy) id (^customUnArchiveBlock)(NSData *data);

/**
 当一个value用文件保存时候,调用这个block获取文件名,默认使用key的md5
 When an object needs to be saved as a file, this block will be invoked to generate
 a file name for a specified key. If the block is nil, the cache use md5(key) as
 default file name.
 
 The default value is nil.
 */
@property (copy) NSString *(^customFilenameBlock)(NSString *key);


#pragma mark - Limit

///=============================================================================
/// @name Limit
///=============================================================================

/**
 The maximum number of objects the cache should hold.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit — if the cache goes over the limit, some objects in the
 cache could be evicted later in background queue.
 */
@property (assign) NSUInteger countLimit;

/**
 The maximum total cost that the cache can hold before it starts evicting objects.
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit — if the cache goes over the limit, some objects in the
 cache could be evicted later in background queue.
 */
@property (assign) NSUInteger costLimit;

/**
 The maximum expiry time of objects in cache.
 
 @discussion The default value is DBL_MAX, which means no limit.
 This is not a strict limit — if an object goes over the limit, the objects could
 be evicted later in background queue.
 */
@property (assign) NSTimeInterval ageLimit;

/**
 磁盘缓存最少保留多少空间,默认是0
 The minimum free disk space (in bytes) which the cache should kept.
 
 @discussion The default value is 0, which means no limit.
 If the free disk space is lower than this value, the cache will remove objects
 to free some disk space. This is not a strict limit—if the free disk space goes
 over the limit, the objects could be evicted later in background queue.
 */
@property (assign) NSTimeInterval freeDiskSpaceLimit;

/**
 检查限制的时间,默认60秒,
 The auto trim check time interval in seconds. Default is 60 (1 minute).
 
 @discussion The cache holds an internal timer to check whether the cache reaches
 its limits, and if the limit is reached, it begins to evict objects.
 */
@property (assign) NSTimeInterval autoTrimInterval;

#pragma mark - Initializer

///=============================================================================
/// @name Initializer
///=============================================================================

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 Create a new cache based on the specified path.
 
 @param path Full path of a directory in which the cache will write data.
 Once initialized you should not read and write to this directory.
 
 @return A new cache object, or nil if an error occurs.
 
 @warning Multiple instances with the same path will make the storage unstable.
 */
- (instancetype)initWithPath:(NSString *)path;

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
             inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

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
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 Returns a boolean value with the block that indicates whether a given key is in cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key   A string identifying the value. If nil, just return NO.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL contains))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the value associated with a given key.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (id<NSCoding>)objectForKey:(NSString *)key;

/**
 Returns the value associated with a given key.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Sets the value of the specified key in the cache.
 This method may blocks the calling thread until file write finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
 Sets the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes the value of the specified key in the cache.
 This method may blocks the calling thread until file delete finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Empties the cache.
 This method may blocks the calling thread until file delete finished.
 */
- (void)removeAllObjects;

/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 不阻塞,带删除的进度
 Empties the cache with block.
 This method returns immediately and executes the clear operation with block in background.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end;


/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the number of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects count.
 */
- (NSInteger)totalCount;

/**
 Get the number of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the total cost (in bytes) of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects cost in bytes.
 */
- (NSInteger)totalCost;

/**
 Get the total cost (in bytes) of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block;


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
- (void)trimToCount:(NSUInteger)count;

/**
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block;

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param age  The maximum age of the object.
 */
- (void)trimToAge:(NSTimeInterval)age;

/**
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param age  The maximum age of the object.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block;


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
+ (NSData *)getExtendedDataFromObject:(id)object;

/**
 在缓存对象被保存到磁盘缓存前,可以设置额外的数据给它.nil,表示删除
 Set extended data to an object.
 
 @discussion You can set any extended data to an object before you save the object
 to disk cache. The extended data will also be saved with this object. You can get
 the extended data later with "getExtendedDataFromObject:".
 
 @param extendedData The extended data (pass nil to remove).
 @param object       The object.
 */
+ (void)setExtendedData:(NSData *)extendedData toObject:(id)object;


@end
























