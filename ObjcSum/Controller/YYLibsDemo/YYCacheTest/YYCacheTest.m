//
//  YYCacheTest.m
//  ObjcSum
//
//  Created by sihuan on 15/12/8.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYCacheTest.h"
#import "YYCache.h"

@interface YYCacheTest ()

@end

@implementation YYCacheTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self memoryCacheBenchmark];
    
    [self diskCacheClearSmallData];
    [self diskCacheClearLargeData];
    
    /**
     *  ===========================
     Disk cache set 1000 key-value pairs (value is NSNumber)
     YYKVFile:       525.61
     YYKVSQLite:     110.87
     YYDiskCache:    123.18
     
     ===========================
     Disk cache set 1000 key-value pairs (value is NSData(100KB))
     YYKVFile:       604.56
     YYKVSQLite:    2151.40
     YYDiskCache:    768.31
     */
    [self diskCacheWriteSmallDataBenchmark];
    [self diskCacheWriteLargeDataBenchmark];
}

- (void)memoryCacheBenchmark {
    NSMutableDictionary *nsDict = [NSMutableDictionary new];
    NSCache *nsCache = [NSCache new];
    YYMemoryCache *yyCache = [YYMemoryCache new];
    yyCache.releaseOnMainThread = YES;
    
    int i = 0;
    NSMutableArray *keys = [NSMutableArray new];
    NSMutableArray *values = [NSMutableArray new];
    int count = 200000;
    for (i = 0; i < count; i++) {
        NSObject *key;
        
        // avoid string compare
        /**
         *  ===========================
         Memory cache set 200000 key-value pairs
         NSDict:      233.61
         YYMemoryCache:    461.18
         NSCache:          598.47
         
         ===========================
         Memory cache set 200000 key-value pairs without resize
         NSDictionary:      94.20
         YYMemoryCache:    425.83
         NSCache:          282.21
         
         ===========================
         Memory cache get 200000 key-value pairs
         NSDictionary:      76.06
         YYMemoryCache:    263.55
         NSCache:          167.37
         */
        key = @(i);
        
        // it will slow down NSCache...
        /**
         *  ===========================
         Memory cache set 200000 key-value pairs
         NSDict:      165.29
         YYMemoryCache:    446.20
         NSCache:         2983.00
         
         ===========================
         Memory cache set 200000 key-value pairs without resize
         NSDictionary:     119.76
         YYMemoryCache:    383.30
         NSCache:         1442.49
         
         ===========================
         Memory cache get 200000 key-value pairs
         NSDictionary:      75.24
         YYMemoryCache:    312.02
         NSCache:         1349.63
         */
//        key = @(i).description;
        
        //key = [NSUUID UUID].UUIDString;
        
        NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
        [keys addObject:key];
        [values addObject:value];
    }
    
    NSTimeInterval begin, end, time;
    
    
    printf("\n===========================\n");
    printf("Memory cache set 200000 key-value pairs\n");
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (i = 0 ; i < count; i++) {
            [nsDict setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSDict:    %8.2f\n", time * 1000);
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yyCache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYMemoryCache:  %8.2f\n", time * 1000);
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [nsCache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSCache:        %8.2f\n", time * 1000);
    
    printf("\n===========================\n");
    printf("Memory cache set 200000 key-value pairs without resize\n");
    
    [nsDict removeAllObjects];
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [nsDict setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSDictionary:   %8.2f\n", time * 1000);
    
    
    
    //[yy removeAllObjects]; // it will rebuild inner cache...
    for (id key in keys) [yyCache removeObjectForKey:key]; // slow than 'removeAllObjects'
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yyCache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYMemoryCache:  %8.2f\n", time * 1000);
    
    
    
    
    [nsCache removeAllObjects];
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [nsCache setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSCache:        %8.2f\n", time * 1000);
    
    
    printf("\n===========================\n");
    printf("Memory cache get 200000 key-value pairs\n");
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [nsDict objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSDictionary:   %8.2f\n", time * 1000);
    
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yyCache objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYMemoryCache:  %8.2f\n", time * 1000);
    
    
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [nsCache objectForKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("NSCache:        %8.2f\n", time * 1000);
    
}

- (void)diskCacheClearSmallData {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    basePath = [basePath stringByAppendingPathComponent:@"FileCacheBenchmarkSmall"];
    [[NSFileManager defaultManager] removeItemAtPath:basePath error:nil];
}


- (void)diskCacheClearLargeData {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    basePath = [basePath stringByAppendingPathComponent:@"FileCacheBenchmarkLarge"];
    [[NSFileManager defaultManager] removeItemAtPath:basePath error:nil];
}

- (void)diskCacheWriteSmallDataBenchmark {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    basePath = [basePath stringByAppendingPathComponent:@"FileCacheBenchmarkSmall"];
    
    YYKVStorage *yykvFile = [[YYKVStorage alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yykvFile"] type:YYKVStorageTypeFile];
    YYKVStorage *yykvSQLite = [[YYKVStorage alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yykvSQLite"] type:YYKVStorageTypeSQLite];
    YYDiskCache *yy = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yy"]];
    
    int count = 1000;
    NSMutableArray *keys = [NSMutableArray new];
    NSMutableArray *values = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSString *key = @(i).description;
        NSNumber *value = @(i);
        [keys addObject:key];
        [values addObject:value];
    }
    
    NSTimeInterval begin, end, time;
    
    printf("\n===========================\n");
    printf("Disk cache set 1000 key-value pairs (value is NSNumber)\n");
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yykvFile saveItemWithKey:keys[i] value:[NSKeyedArchiver archivedDataWithRootObject:values[i]] filename:keys[i] extendedData:nil];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYKVFile:     %8.2f\n", time * 1000);
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yykvSQLite saveItemWithKey:keys[i] value:[NSKeyedArchiver archivedDataWithRootObject:values[i]]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYKVSQLite:   %8.2f\n", time * 1000);
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yy setObject:values[i] forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYDiskCache:  %8.2f\n", time * 1000);
    
    
    
}


- (void)diskCacheWriteLargeDataBenchmark {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    basePath = [basePath stringByAppendingPathComponent:@"FileCacheBenchmarkLarge"];
    
    YYKVStorage *yykvFile = [[YYKVStorage alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yykvFile"] type:YYKVStorageTypeFile];
    YYKVStorage *yykvSQLite = [[YYKVStorage alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yykvSQLite"] type:YYKVStorageTypeSQLite];
    YYDiskCache *yy = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"yy"]];
    yy.customArchiveBlock = ^(id object) {return object;};
    yy.customUnArchiveBlock = ^(NSData *object) {return object;};
    
    int count = 1000;
    NSMutableArray *keys = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSString *key = @(i).description;
        [keys addObject:key];
    }
    NSMutableData *dataValue = [NSMutableData new]; // 32KB
    for (int i = 0; i < 100 * 1024; i++) {
        [dataValue appendBytes:&i length:1];
    }
    
    NSTimeInterval begin, end, time;
    
    
    printf("\n===========================\n");
    printf("Disk cache set 1000 key-value pairs (value is NSData(100KB))\n");
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yykvFile saveItemWithKey:keys[i] value:dataValue filename:keys[i] extendedData:nil];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYKVFile:     %8.2f\n", time * 1000);
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yykvSQLite saveItemWithKey:keys[i] value:dataValue];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYKVSQLite:   %8.2f\n", time * 1000);
    
    
    begin = CACurrentMediaTime();
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            [yy setObject:dataValue forKey:keys[i]];
        }
    }
    end = CACurrentMediaTime();
    time = end - begin;
    printf("YYDiskCache:  %8.2f\n", time * 1000);
    
}















@end
