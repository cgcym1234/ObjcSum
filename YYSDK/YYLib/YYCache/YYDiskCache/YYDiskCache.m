//
//  YYDiskCache.m
//  ObjcSum
//
//  Created by sihuan on 15/12/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYDiskCache.h"
#import "YYKVStorage.h"

#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import <time.h>

#define Lock() dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(_lock)

#define _WeakSelf(x) __weak typeof(self) x = self
#define _StrongSelf(x) __strong typeof(self) x = weakSelf
#define WeakSelf() _WeakSelf(weakSelf)
#define StrongSelf() _StrongSelf(strongSelf)

static const int extendedDataKey;

/**
 *  获取可用磁盘的大小
 */
static int64_t _diskSpaceFree() {
    NSError *error;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:NSHomeDirectory() error:&error];
    if (!attrs) return  -1;
    //NSFileSystemSize 总大小
    int64_t space = [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    return space < 0 ? -1 : space;
}

static NSString *_md5FromString(NSString *string) {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@interface YYDiskCache ()

@property (nonatomic, strong) YYKVStorage *kvStore;
@property (nonatomic, strong) dispatch_semaphore_t lock;

//异步接口使用
@property (nonatomic, strong) dispatch_queue_t queueConcurrent;

@end

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
        YYKVStorageType type;
        if (threshold <= 0) {
            type = YYKVStorageTypeFile;
        } else if (threshold >= NSUIntegerMax) {
            type = YYKVStorageTypeSQLite;
        } else {
            type = YYKVStorageTypeMixed;
        }
        
        YYKVStorage *kvStore = [[YYKVStorage alloc] initWithPath:path type:type];
        if (!kvStore) {
            return nil;
        }
        
        _kvStore = kvStore;
        _path = path;
        _lock = dispatch_semaphore_create(1);
        _queueConcurrent = dispatch_queue_create("com.ibireme.cache.disk", DISPATCH_QUEUE_CONCURRENT);
        _inlineThreshold = threshold;
        _countLimit = NSUIntegerMax;
        _costLimit = NSUIntegerMax;
        _ageLimit = DBL_MAX;
        _freeDiskSpaceLimit = 0;
        _autoTrimInterval = 60;
        [self _trimRecursively];
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
    if (!key) return NO;

    Lock();
    BOOL contains = [_kvStore itemExistsForKey:key];
    Unlock();
    return contains;
}

/**
 Returns a boolean value with the block that indicates whether a given key is in cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key   A string identifying the value. If nil, just return NO.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL contains))block {
    if (!block) return;
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        BOOL contains = [strongSelf containsObjectForKey:key];
        block(key, contains);
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the value associated with a given key.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (id<NSCoding>)objectForKey:(NSString *)key {
    if (!key) return nil;
    Lock();
    YYKVStorageItem *item = [_kvStore getItemForKey:key];
    Unlock();
    
    if (!item.value) return nil;
    id obj;
    if (_customArchiveBlock) {
        obj = _customArchiveBlock(item.value);
    } else {
        @try {
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:item.value];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    
    if (obj && item.extendedData) {
//        [YYDiskCache setExtendedData:item.extendedData toObject:obj];
    }
    return obj;
}

/**
 Returns the value associated with a given key.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block {
    if (!block) return;
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        block(key, [strongSelf objectForKey:key]);
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Sets the value of the specified key in the cache.
 This method may blocks the calling thread until file write finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    if (!key) return;
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    NSData *extendedData = [YYDiskCache getExtendedDataFromObject:object];
    NSData *value = nil;
    if (_customArchiveBlock) {
        value = _customArchiveBlock(object);
    } else {
        @try {
            value = [NSKeyedArchiver archivedDataWithRootObject:object];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    if (!value) return;
    NSString *filename;
    if (_kvStore.type != YYKVStorageTypeSQLite && value.length > _inlineThreshold) {
        filename = [self _filenameForKey:key];
    }
    
    Lock();
    [_kvStore saveItemWithKey:key value:value filename:filename extendedData:extendedData];
    Unlock();
}

/**
 Sets the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf setObject:object forKey:key];
        if (block) {
            block();
        }
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes the value of the specified key in the cache.
 This method may blocks the calling thread until file delete finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(NSString *)key {
    if (!key) return;
    Lock();
    [_kvStore removeItemForKey:key];
    Unlock();
}

/**
 Removes the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf removeObjectForKey:key];
        if (block) {
            block(key);
        }
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Empties the cache.
 This method may blocks the calling thread until file delete finished.
 */
- (void)removeAllObjects {
    Lock();
    [_kvStore removeAllItems];
    Unlock();
}

/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf removeAllObjects];
        if (block) {
            block();
        }
    });
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
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        if (!strongSelf) {
            if (end) {
                end(YES);
            }
        }
        dispatch_semaphore_wait(strongSelf.lock, DISPATCH_TIME_FOREVER);
        [strongSelf.kvStore removeAllItemsWithProgressBlock:progress endBlock:end];
        dispatch_semaphore_signal(strongSelf.lock);
    });
}


/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the number of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects count.
 */
- (NSInteger)totalCount {
    Lock();
    int count = [_kvStore getItemsCount];
    Unlock();
    return count;
}

/**
 Get the number of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block {
    if (!block) return;
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        block([strongSelf totalCount]);
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Returns the total cost (in bytes) of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects cost in bytes.
 */
- (NSInteger)totalCost {
    Lock();
    int count = [_kvStore getItemsSize];
    Unlock();
    return count;
}

/**
 Get the total cost (in bytes) of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block {
    if (!block) return;
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        block([strongSelf totalCost]);
    });
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
    Lock();
    [self _trimToCount:count];
    Unlock();
}

/**
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf _trimToCount:count];
        if (block) block();
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost {
    Lock();
    [self _trimToCost:cost];
    Unlock();
}

/**
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf _trimToCost:cost];
        if (block) block();
    });
}

/**
 这个方法会阻塞调用的线程直到查找结束,下面带block参数的方式不会阻塞
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param age  The maximum age of the object.
 */
- (void)trimToAge:(NSTimeInterval)age {
    Lock();
    [self _trimToAge:age];
    Unlock();
}

/**
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param age  The maximum age of the object.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block {
    WeakSelf();
    dispatch_async(_queueConcurrent, ^{
        StrongSelf();
        [strongSelf _trimToAge:age];
        if (block) block();
    });
}

- (NSString *)description {
    if (_name) return [NSString stringWithFormat:@"<%@: %p> (%@:%@)", self.class, self, _name, _path];
    else return [NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _path];
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
    if (!object) return nil;
    return (NSData *)objc_getAssociatedObject(object, &extendedDataKey);
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
    if (!object) return;
    objc_setAssociatedObject(object, &extendedDataKey, extendedData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private

- (NSString *)_filenameForKey:(NSString *)key {
    NSString *filename = nil;
    if (_customFilenameBlock) filename = _customFilenameBlock(key);
    if (!filename) filename = _md5FromString(key);
    return filename;
}

- (void)_trimRecursively {
    __weak typeof(self) _self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong typeof(_self) self = _self;
        if (!self) return;
        [self _trimInBackground];
        [self _trimRecursively];
    });
}

- (void)_trimInBackground {
    __weak typeof(self) _self = self;
    dispatch_async(_queueConcurrent, ^{
        __strong typeof(_self) self = _self;
        if (!self) return;
        dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
        [self _trimToCost:self.costLimit];
        [self _trimToCount:self.countLimit];
        [self _trimToAge:self.ageLimit];
        [self _trimToFreeDiskSpace:self.freeDiskSpaceLimit];
        dispatch_semaphore_signal(self->_lock);
    });
}

- (void)_trimToCount:(NSUInteger)countLimit {
    if (countLimit >= INT_MAX) return;
    [_kvStore removeItemsToFitCount:(int)countLimit];
}

- (void)_trimToCost:(NSUInteger)costLimit {
    if (costLimit >= INT_MAX) return;
    [_kvStore removeItemsToFitSize:(int)costLimit];
    
}

- (void)_trimToAge:(NSTimeInterval)ageLimit {
    if (ageLimit <= 0) {
        [_kvStore removeAllItems];
        return;
    }
    long timestamp = time(NULL);
    if (timestamp <= ageLimit) {
        return;
    }
    
    long age = timestamp - ageLimit;
    if (age >= INT_MAX) return;
    [_kvStore removeItemsEarlierThanTime:(int)age];
}

- (void)_trimToFreeDiskSpace:(NSUInteger)targetFreeDiskSpace {
    if (targetFreeDiskSpace == 0) return;
    int64_t totalBytes = [_kvStore getItemsSize];
    if (totalBytes <= 0) return;
    int64_t diskFreeBytes = _diskSpaceFree();
    if (diskFreeBytes < 0) return;
    int64_t needTrimBytes = targetFreeDiskSpace - diskFreeBytes;
    if (needTrimBytes <= 0) return;
    int64_t costLimit = totalBytes - needTrimBytes;
    if (costLimit < 0) costLimit = 0;
    [self _trimToCost:(int)costLimit];
}


@end














