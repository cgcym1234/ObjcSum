//
//  YYMemoryCache.m
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMemoryCache.h"
#import "YYLinkedMap.h"

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

static inline dispatch_queue_t YYMemoryCacheGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

@implementation YYMemoryCache {
    OSSpinLock _lock;           //自旋锁
    YYLinkedMap *_lru;          //双向链表
    dispatch_queue_t _queue;    //串行队列
}

- (instancetype)init {
    self = [super init];
    _lock = OS_SPINLOCK_INIT;
    _lru = [YYLinkedMap new];
    _queue = dispatch_queue_create("com.huan.cache.memory", DISPATCH_QUEUE_SERIAL);
    
    _countLimit = NSUIntegerMax;
    _costLimit = NSUIntegerMax;
    _ageLimit = DBL_MAX;
    _autoTrimInterval = 5.0;
    _shouldRemoveAllObjectsOnMemoryWarning = YES;
    _shouldRemoveAllObjectsWhenEnteringBackground = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self _trimRecursively];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [_lru removeAll];
}

- (NSUInteger)totalCount {
    OSSpinLockLock(&_lock);
    NSUInteger count = _lru->_totalCount;
    OSSpinLockUnlock(&_lock);
    return count;
}

- (NSUInteger)totalCost {
    OSSpinLockLock(&_lock);
    NSUInteger totalCost = _lru->_totalCost;
    OSSpinLockUnlock(&_lock);
    return totalCost;
}

- (BOOL)releaseInMainThread {
    OSSpinLockLock(&_lock);
    BOOL releaseInMainThread = _lru->_releaseOnMainThread;
    OSSpinLockUnlock(&_lock);
    return releaseInMainThread;
}

- (void)setReleaseInMainThread:(BOOL)releaseInMainThread {
    OSSpinLockLock(&_lock);
    _lru->_releaseOnMainThread = releaseInMainThread;
    OSSpinLockUnlock(&_lock);
}

- (BOOL)releaseAsynchronously {
    OSSpinLockLock(&_lock);
    BOOL releaseAsynchronously = _lru->_releaseAsynchronously;
    OSSpinLockUnlock(&_lock);
    return releaseAsynchronously;
}

- (void)setReleaseAsynchronously:(BOOL)releaseAsynchronously {
    OSSpinLockLock(&_lock);
    _lru->_releaseAsynchronously = releaseAsynchronously;
    OSSpinLockUnlock(&_lock);
}


#pragma mark - Access Methods

///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 Returns a Boolean value that indicates whether a given key is in cache.
 
 @param key An object identifying the value. If nil, just return `NO`.
 @return Whether the key is in cache.
 */
- (BOOL)containsObjectForKey:(id)key {
    if (!key) {
        return NO;
    }
    OSSpinLockLock(&_lock);
    BOOL contains = [_lru->_dict objectForKey:key] != nil;
    OSSpinLockUnlock(&_lock);
    return contains;
}

/**
 Returns the value associated with a given key.
 
 @param key An object identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (id)objectForKey:(id)key {
    if (!key) return nil;
    OSSpinLockLock(&_lock);
    YYLinkedMapNode *node = [_lru->_dict objectForKey:key];
    if (node) {
        node->_time = CACurrentMediaTime();
        [_lru bringNodeToHead:node];
    }
    OSSpinLockUnlock(&_lock);
    return node ? node->_value : nil;
}

/**
 Sets the value of the specified key in the cache (0 cost).
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(id)object forKey:(id)key {
    [self setObject:object forKey:key withCost:0];
}

/**
 Sets the value of the specified key in the cache, and associates the key-value
 pair with the specified cost.
 
 @param object The object to store in the cache. If nil, it calls `removeObjectForKey`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 @param cost   The cost with which to associate the key-value pair.
 @discussion Unlike an NSMutableDictionary object, a cache does not copy the key
 objects that are put into it.
 */
- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost {
    if (!key) return;
    
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    OSSpinLockLock(&_lock);
    
    NSTimeInterval now = CACurrentMediaTime();
    YYLinkedMapNode *node = [_lru->_dict objectForKey:key];
    if (node) {
        _lru->_totalCost += cost - node->_cost;
        node->_value = object;
        node->_key = key;
        node->_cost = cost;
        node->_time = now;
        [_lru bringNodeToHead:node];
    } else {
        node = [YYLinkedMapNode new];
        node->_value = object;
        node->_key = key;
        node->_cost = cost;
        node->_time = now;
        [_lru insertNodeAtHead:node];
    }
    
    /**
     *  超过限制则移除掉末尾节点
     */
    if (_lru->_totalCount > _countLimit) {
        YYLinkedMapNode *tail = [_lru removeTailNode];
        if (tail) {
            if (_lru->_releaseAsynchronously) {
                dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
                dispatch_async(queue, ^{
                    //巧妙的方式,在指定线程中释放tail,hold and release in queue
                    [tail class];
                });
            } else if (_lru->_releaseOnMainThread && !pthread_main_np()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tail class]; //hold and release in queue
                });
            }

        }
    }
    OSSpinLockUnlock(&_lock);
}

/**
 Removes the value of the specified key in the cache.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    OSSpinLockLock(&_lock);
    YYLinkedMapNode *node = [_lru->_dict objectForKey:key];
    if (node) {
        [_lru removeNode:node];
        if (_lru->_releaseAsynchronously) {
            dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
            dispatch_async(queue, ^{
                //巧妙的方式,在指定线程中释放tail,hold and release in queue
                [node class];
            });
        } else if (_lru->_releaseOnMainThread && !pthread_main_np()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [node class]; //hold and release in queue
            });
        }
    }
    OSSpinLockUnlock(&_lock);
}

/**
 Empties the cache immediately.
 */
- (void)removeAllObjects {
    OSSpinLockLock(&_lock);
    [_lru removeAll];
    OSSpinLockUnlock(&_lock);
}


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
- (void)trimToCount:(NSUInteger)count {
    [self _trimToCount:count];
}

/**
 类似上面
 Removes objects from the cache with LRU, until the `totalCost` is or equal to
 the specified value.
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost {
    [self _trimToCost:cost];
}

/**
 Removes objects from the cache with LRU, until all expiry objects removed by the
 specified value.
 @param age  The maximum age (in seconds) of objects.
 */
- (void)trimToAge:(NSTimeInterval)age {
    [self _trimToAge:age];
}

#pragma mark - Private

/**
 *  在DISPATCH_QUEUE_PRIORITY_LOW线程中每隔_autoTrimInterval秒递归做监控
 */
- (void)_trimRecursively {
    if (_autoTrimInterval <= 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (!weakSelf) return;
        [weakSelf _trimInBackground];
        [weakSelf _trimRecursively];
    });
}

/**
 *  检查任务全部放到串行队列中执行
 */
- (void)_trimInBackground {
    dispatch_async(_queue, ^{
        [self _trimToCost:_costLimit];
        [self _trimToCount:_countLimit];
        [self _trimToAge:_ageLimit];
    });
}

- (void)_trimToCost:(NSUInteger)costLimit {
    BOOL finish = NO;
    OSSpinLockUnlock(&_lock);
    if (costLimit == 0) {
        [_lru removeAll];
        finish = YES;
    } else if (_lru->_totalCount <= costLimit) {
        finish = YES;
    }
    OSSpinLockUnlock(&_lock);
    if (finish) {
        return;
    }
    
    //retain要移除的节点,一次释放
    NSMutableArray *holder = [NSMutableArray new];
    while (!finish) {
        if (OSSpinLockTry(&_lock)) {
            if (_lru->_totalCount > costLimit) {
                //移除末尾节点
                YYLinkedMapNode *node = [_lru removeTailNode];
                if (node) {
                    [holder addObject:node];
                } else {
                    finish = YES;
                }
            }
            OSSpinLockUnlock(&_lock);
        } else {
            //10 ms 后再尝试
            usleep(10 * 1000);
        }
    }
    
    if (holder.count) {
        dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
        dispatch_async(queue, ^{
            [holder count]; // release in queue
        });
    }
}

- (void)_trimToCount:(NSUInteger)countLimit {
    BOOL finish = NO;
    OSSpinLockLock(&_lock);
    if (countLimit == 0) {
        [_lru removeAll];
        finish = YES;
    } else if (_lru->_totalCount <= countLimit) {
        finish = YES;
    }
    OSSpinLockUnlock(&_lock);
    if (finish) return;
    
    NSMutableArray *holder = [NSMutableArray new];
    while (!finish) {
        if (OSSpinLockTry(&_lock)) {
            if (_lru->_totalCount > countLimit) {
                YYLinkedMapNode *node = [_lru removeTailNode];
                if (node) [holder addObject:node];
            } else {
                finish = YES;
            }
            OSSpinLockUnlock(&_lock);
        } else {
            usleep(10 * 1000); //10 ms
        }
    }
    if (holder.count) {
        dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
        dispatch_async(queue, ^{
            [holder count]; // release in queue
        });
    }
}

- (void)_trimToAge:(NSTimeInterval)ageLimit {
    BOOL finish = NO;
    NSTimeInterval now = CACurrentMediaTime();
    OSSpinLockLock(&_lock);
    if (ageLimit <= 0) {
        [_lru removeAll];
        finish = YES;
    } else if (!_lru->_tail || (now - _lru->_tail->_time) <= ageLimit) {
        finish = YES;
    }
    OSSpinLockUnlock(&_lock);
    if (finish) return;
    
    NSMutableArray *holder = [NSMutableArray new];
    while (!finish) {
        if (OSSpinLockTry(&_lock)) {
            if (_lru->_tail && (now - _lru->_tail->_time) > ageLimit) {
                YYLinkedMapNode *node = [_lru removeTailNode];
                if (node) [holder addObject:node];
            } else {
                finish = YES;
            }
            OSSpinLockUnlock(&_lock);
        } else {
            usleep(10 * 1000); //10 ms
        }
    }
    if (holder.count) {
        dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
        dispatch_async(queue, ^{
            [holder count]; // release in queue
        });
    }

}

- (void)_appDidReceiveMemoryWarningNotification {
    if (self.didReceiveMemoryWarningBlock) {
        self.didReceiveMemoryWarningBlock(self);
    }
    if (self.shouldRemoveAllObjectsOnMemoryWarning) {
        [self removeAllObjects];
    }
}

- (void)_appDidEnterBackgroundNotification {
    if (self.didEnterBackgroundBlock) {
        self.didEnterBackgroundBlock(self);
    }
    if (self.shouldRemoveAllObjectsWhenEnteringBackground) {
        [self removeAllObjects];
    }
}





@end
