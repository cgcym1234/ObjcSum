//
//  YYCache.h
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `YYCache` is a thread safe key-value cache.
 
 It use `YYMemoryCache` to store objects in a small and fast memory cache,
 and use `YYDiskCache` to persisting objects to a large and slow disk cache.
 See `YYMemoryCache` and `YYDiskCache` for more information.
 */
@interface YYCache : NSObject

/** The name of the cache, readonly. */
@property (nonatomic, copy, readonly) NSString *name;

@end
