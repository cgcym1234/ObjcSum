//
//  YYKVStorage.m
//  ObjcSum
//
//  Created by sihuan on 15/12/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYKVStorage.h"

#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>
#import <time.h>

#if __has_include(<sqlite3.h>)
#import <sqlite3.h>
#else
#import "sqlite3.h"
#endif

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

typedef enum {
    //无返回
    YYSqliteTypeNone,
    YYSqliteTypeInt,
    YYSqliteTypeText,
}YYSqliteType;

#pragma mark - Sqlite Wal Shm

static const int kPathLengthMax = PATH_MAX - 64;
static NSString *const kDBFilename = @"manifest.sqlite";
static NSString *const kDBShmFilename = @"manifest.sqlite-shm";
static NSString *const kDBWalFilename = @"manifest.sqlite-wal";
static NSString *const kDataDirectoryName = @"data";
static NSString *const kTrashDirectoryName = @"trash";

/*
 SQL:
 create table if not exists manifest (
 key                 text,
 filename            text,
 size                integer,
 inline_data         blob,
 modification_time   integer,
 last_access_time    integer,
 extended_data       blob,
 primary key(key)
 );
 create index if not exists last_access_time_idx on manifest(last_access_time);
 */

/**
 SQLite在3.7.0版本引入了WAL (Write-Ahead-Logging),WAL的全称是Write Ahead Logging，它是很多数据库中用于实现原子事务的一种机制,引入WAL机制之前，SQLite使用rollback journal机制实现原子事务。
 
 rollback journal机制的原理是：在修改数据库文件中的数据之前，先将修改所在分页中的数据备份在另外一个地方，然后才将修改写入到数据库文件中；如果事务失败，则将备份数据拷贝回来，撤销修改；如果事务成功，则删除备份数据，提交修改。
 
 WAL机制的原理是：修改并不直接写入到数据库文件中，而是写入到另外一个称为WAL的文件中；如果事务失败，WAL中的记录会被忽略，撤销修改；如果事务成功，它将在随后的某个时间被写回到数据库文件中，提交修改。
 
 同步WAL文件和数据库文件的行为被称为checkpoint（检查点），它由SQLite自动执行，默认是在WAL文件积累到1000页修改的时候；当然，在适当的时候，也可以手动执行checkpoint，SQLite提供了相关的接口。执行checkpoint之后，WAL文件会被清空。
 在读的时候，SQLite将在WAL文件中搜索，找到最后一个写入点，记住它，并忽略在此之后的写入点（这保证了读写和读读可以并行执行）；随后，它确定所要读的数据所在页是否在WAL文件中，如果在，则读WAL文件中的数据，如果不在，则直接读数据库文件中的数据。
 在写的时候，SQLite将之写入到WAL文件中即可，但是必须保证独占写入，因此写写之间不能并行执行。
 WAL在实现的过程中，使用了共享内存技术，因此，所有的读写进程必须在同一个机器上，否则，无法保证数据一致性。
 */

#pragma mark - sqlite简单封装,c风格

#define DbError -1
#define DbScucess 1

int dbClose(sqlite3 *db) {
    if (db) {
        int result = 0;
        
        //关闭失败,再尝试关闭一次
        int retry = 0;
        int stmtFinalized = 0;
        
        do {
            result = sqlite3_close(db);
            if (result == SQLITE_BUSY || result == SQLITE_LOCKED) {
                if (!stmtFinalized) {
                    stmtFinalized = 1;
                    sqlite3_stmt *stmt;
                    while ((stmt = sqlite3_next_stmt(db, nil)) != SQLITE_OK) {
                        sqlite3_finalize(stmt);
                        retry = 1;
                    }
                }
            } else if (result != SQLITE_OK) {
                printf("deClose failed, error:[%s]\n", sqlite3_errmsg(db));
            }
        } while (retry);
        
        return result == SQLITE_OK ? DbScucess : DbError;
    }
    return DbError;
}

/**
 *  获取数据库句柄
 */
sqlite3 * dbGetHandleWithPath(const char *dbPath) {
    sqlite3 *db = NULL;
    
    //1.打开数据库文件（如果数据库文件不存在，那么该函数会自动创建数据库文件）
    if (sqlite3_open(dbPath, &db) != SQLITE_OK) {
        //需要关闭，因为即使open失败。db也不为空
        dbClose(db);
        db = NULL;
        printf("open db error, path:[%s]\n", dbPath);
    }
    return db;
}

/**
 *  将sql文本转换成一个准备语句（prepared statement）对象，同时返回这个对象的指针
 */
sqlite3_stmt * dbPrepareSqlStmt(sqlite3 *db, const char *sql) {
    sqlite3_stmt *stmt = NULL;
    if (!db || !sql) {
        goto error;
    }
    
    int len = (int)strlen(sql);
    //    int result = 0;
    
    /**
     *  将sql文本转换成一个准备语句（prepared statement）对象，同时返回这个对象的指针。
     它实际上并不执行（evaluate）这个SQL语句，它仅仅为执行准备这个sql语句
     */
    if (sqlite3_prepare_v2(db, sql, len, &stmt, NULL) != SQLITE_OK) {
        goto error;
    }
    
    return stmt;
    
error:
    if (stmt) {
        sqlite3_finalize(stmt);
    }
    
    printf("dbPrepareSqlStmt failed, error:[%s]\n", sqlite3_errmsg(db));
    return NULL;
}

/**
 *  执行一条sql
 */
int dbExecSql(sqlite3 *db, const char *sql) {
    sqlite3_stmt *stmt = dbPrepareSqlStmt(db, sql);
    if (!stmt) {
        goto error;
    }
    
    /**
     *  通过sqlite3_step命令执行sql语句。对于DDL和DML语句而言，sqlite3_step执行正确的返回值只有SQLITE_DONE
     对于SELECT查询而言，如果有数据返回SQLITE_ROW，当到达结果集末尾时则返回SQLITE_DONE
     */
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        goto error;
    }
    
    //释放资源。
    sqlite3_finalize(stmt);
    return DbScucess;
    
error:
    if (stmt) {
        sqlite3_finalize(stmt);
    }
    printf("dbExecSql failed, error:[%s]\n", sqlite3_errmsg(db));
    return DbError;
}

/**
 *  开启一个事务执行多条sql
 */
int dbExecSqls(sqlite3 *db, char **sqls) {
    sqlite3_stmt *stmt = NULL;
    
    /**
     *  显式的开启一个事务。
     */
    const char* beginSQL = "BEGIN";
    assert(dbExecSql(db, beginSQL) == DbScucess);
    
    
    char **iterator = sqls;
    while (*iterator) {
        stmt = dbPrepareSqlStmt(db, *iterator);
        if (dbExecSql(db, *iterator) == DbError) {
            //任何一条sql执行失败就回滚
            assert(dbExecSql(db, "ROLLBACK") == DbScucess);
            goto error;
        }
        iterator++;
    }
    
    /**
     *  提交事务。
     */
    const char* commitSQL = "COMMIT";
    assert(dbExecSql(db, commitSQL) == DbScucess);
    
error:
    if (stmt) {
        sqlite3_finalize(stmt);
    }
    return DbError;
}

#pragma mark - YYKVStorageItem
@implementation YYKVStorageItem
@end

#pragma mark - YYKVStorage
@implementation YYKVStorage {
    //回收站操作队列
    dispatch_queue_t _trashQueue;
    
    //路径
    NSString *_path;
    NSString *_dbPath;
    NSString *_dataPath;
    NSString *_trashPath;
    
    sqlite3 *_dbHandle;
    NSMutableDictionary *_dbStmtCache;
    
    ///< If YES, then the db should not open again, all read/write should be ignored.
    BOOL _invalidated;
    
    ///< If YES, then the db is during closing.
    BOOL _dbIsClosing;
    
    OSSpinLock _dbStateLock;
}

#pragma mark - Public

#pragma mark Initializer

///=============================================================================
/// @name Initializer
///=============================================================================

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YYKVStorage init error" reason:@"Please use the designated initializer and pass the 'path' and 'type'." userInfo:nil];
    return [self initWithPath:nil type:YYKVStorageTypeFile];
}

/**
 The designated initializer.
 
 @param path  Full path of a directory in which the storage will write data. If
 the directory is not exists, it will try to create one, otherwise it will
 read the data in this directory.
 @param type  The storage type. After first initialized you should not change the
 type of the specified path.
 @return  A new storage object, or nil if an error occurs.
 @warning Multiple instances with the same path will make the storage unstable.
 */
- (instancetype)initWithPath:(NSString *)path type:(YYKVStorageType)type {
    if (path.length == 0 || path.length > kPathLengthMax) {
        debugLog(@"YYKVStorage init error: invalid path: [%@].", path);
        return nil;
    }
    if (type > YYKVStorageTypeMixed) {
        debugLog(@"YYKVStorage init error: invalid type: %lu.", (unsigned long)type);
        return nil;
    }
    
    self = [super init];
    if (self) {
        _path = path.copy;
        _type = type;
        _dataPath = [path stringByAppendingPathComponent:kDataDirectoryName];
        _trashPath = [path stringByAppendingPathComponent:kTrashDirectoryName];
        _trashQueue = dispatch_queue_create("com.ibireme.cache.disk.trash", DISPATCH_QUEUE_SERIAL);
        _dbPath = [path stringByAppendingPathComponent:kDBFilename];
        _dbStateLock = OS_SPINLOCK_INIT;
        _errorLogsEnabled = YES;
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error] ||
            ![[NSFileManager defaultManager] createDirectoryAtPath:_dataPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error] ||
            ![[NSFileManager defaultManager] createDirectoryAtPath:_trashPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error]) {
                debugLog(@"YYKVStorage init error:%@", error);
                return nil;
            }
    }
    
    if (![self _dbOpen] || ![self _dbInitialize]) {
        // db file may broken...
        [self _dbClose];
        
        // rebuild 一次
        [self _reset];
        
        if (![self _dbOpen] || ![self _dbInitialize]) {
            // db file may broken...
            [self _dbClose];
            debugLog(@"YYKVStorage init error: fail to open sqlite db.");
            return nil;
        }
    }
    
    // empty the trash if failed at last time
    [self _fileEmptyTrashInBackground];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appWillBeTerminated) name:UIApplicationWillTerminateNotification object:nil];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [self _dbClose];
}

#pragma mark Save Items

///=============================================================================
/// @name Save Items
///=============================================================================

/**
 保存或更新,存储 item.key, item.value, item.filename 和item.extendedData,其他属性忽略
 
 Save an item or update the item with 'key' if it already exists.
 
 @discussion This method will save the item.key, item.value, item.filename and
 item.extendedData to disk or sqlite, other properties will be ignored. item.key
 and item.value should not be empty (nil or zero length).
 
 If the `type` is YYKVStorageTypeFile, then the item.filename should not be empty.
 If the `type` is YYKVStorageTypeSQLite, then the item.filename will be ignored.
 It the `type` is YYKVStorageTypeMixed, then the item.value will be saved to file
 system if the item.filename is not empty, otherwise it will be saved to sqlite.
 
 @param item  An item.
 @return Whether succeed.
 */
- (BOOL)saveItem:(YYKVStorageItem *)item {
    return [self saveItemWithKey:item.key value:item.value filename:item.filename extendedData:item.extendedData];
}

/**
 只保存到key,value 到sqlite中,其他忽略,
 而且如果类型是YYKVStorageTypeFile,那么会返回失败
 Save an item or update the item with 'key' if it already exists.
 
 @discussion This method will save the key-value pair to sqlite. If the `type` is
 YYKVStorageTypeFile, then this method will failed.
 
 @param key   The key, should not be empty (nil or zero length).
 @param value The key, should not be empty (nil or zero length).
 @return Whether succeed.
 */
- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value {
    return [self saveItemWithKey:key value:value filename:nil extendedData:nil];
}

/**
 Save an item or update the item with 'key' if it already exists.
 
 @discussion
 If the `type` is YYKVStorageTypeFile, then the `filename` should not be empty.
 If the `type` is YYKVStorageTypeSQLite, then the `filename` will be ignored.
 It the `type` is YYKVStorageTypeMixed, then the `value` will be saved to file
 system if the `filename` is not empty, otherwise it will be saved to sqlite.
 
 @param key           The key, should not be empty (nil or zero length).
 @param value         The key, should not be empty (nil or zero length).
 @param filename      The filename.
 @param extendedData  The extended data for this item (pass nil to ignore it).
 
 @return Whether succeed.
 */
- (BOOL)saveItemWithKey:(NSString *)key
                  value:(NSData *)value
               filename:(NSString *)filename
           extendedData:(NSData *)extendedData {
    if (key.length == 0 || value.length == 0) return NO;
    if (_type == YYKVStorageTypeFile && filename.length == 0) {
        return NO;
    }
    
    //存到文件中
    if (filename.length) {
        //value数据存储到文件中
        if (![self _fileWriteWithName:filename data:value]) {
            return NO;
        }
        
        //其他信息存储到sqllite中
        if (![self _dbSaveWithKey:key value:value filename:filename extendedData:extendedData]) {
            [self _fileDeleteWithName:filename];
            return NO;
        }
        return YES;
    } else {
        /**
         存储到sqlite中,除非设置了数据只存储在sqlite中
         否则先判断下删除文件的逻辑
         */
        if (_type != YYKVStorageTypeSQLite) {
            NSString *filenameKey = [self _dbGetFilenameWithKey:key];
            if (filenameKey) {
                [self _fileDeleteWithName:filenameKey];
            }
        }
        return [self _dbSaveWithKey:key value:value filename:nil extendedData:extendedData];
    }
}

#pragma mark - Remove Items
///=============================================================================
/// @name Remove Items
///=============================================================================

/**
 Remove an item with 'key'.
 
 @param key The item's key.
 @return Whether succeed.
 */
- (BOOL)removeItemForKey:(NSString *)key {
    if (key.length == 0) return NO;
    switch (_type) {
        case YYKVStorageTypeSQLite:
            return [self _dbDeleteItemWithKey:key];
            break;
        case YYKVStorageTypeFile:
        case YYKVStorageTypeMixed: {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename) {
                [self _fileDeleteWithName:filename];
            }
            return [self _dbDeleteItemWithKey:key];
        }
        default:
            break;
    }
    return NO;
}

/**
 Remove items with an array of keys.
 
 @param keys An array of specified keys.
 
 @return Whether succeed.
 */
- (BOOL)removeItemForKeys:(NSArray *)keys {
    if (keys.count == 0) return NO;
    switch (_type) {
        case YYKVStorageTypeSQLite: {
            return [self _dbDeleteItemWithKeys:keys];
        }
        case YYKVStorageTypeFile:
        case YYKVStorageTypeMixed: {
            NSArray *filenames = [self _dbGetFilenameWithKeys:keys];
            for (NSString *filename in filenames) {
                [self _fileDeleteWithName:filename];
            }
            return [self _dbDeleteItemWithKeys:keys];
        }
    }
    return NO;
}

/**
 Remove all items which `value` is larger than a specified size.
 
 @param size  The maximum size in bytes.
 @return Whether succeed.
 */
- (BOOL)removeItemsLargerThanSize:(int)size {
    if (size >= INT_MAX) {
        return YES;
    }
    if (size <= 0) {
        return [self removeAllItems];
    }
    
    switch (_type) {
        case YYKVStorageTypeSQLite: {
            return [self _dbDeleteItemsWithSizeLargerThan:size];
        }
        case YYKVStorageTypeFile:
        case YYKVStorageTypeMixed: {
            NSArray *filenames = [self _dbGetFilenamesWithSizeLargerThan:size];
            for (NSString *filename in filenames) {
                [self _fileDeleteWithName:filename];
            }
            return [self _dbDeleteItemsWithSizeLargerThan:size];
        }
    }
    return NO;
}

/**
 Remove all items which last access time is earlier than a specified timestamp.
 
 @param time  The specified unix timestamp.
 @return Whether succeed.
 */
- (BOOL)removeItemsEarlierThanTime:(int)time {
    if (time <= 0) return YES;
    if (time == INT_MAX) return [self removeAllItems];
    
    switch (_type) {
        case YYKVStorageTypeSQLite: {
            return [self _dbDeleteItemsWithTimeEarlierThan:time];
        } break;
        case YYKVStorageTypeFile:
        case YYKVStorageTypeMixed: {
            NSArray *filenames = [self _dbGetFilenamesWithTimeEarlierThan:time];
            for (NSString *name in filenames) {
                [self _fileDeleteWithName:name];
            }
            return [self _dbDeleteItemsWithTimeEarlierThan:time];
        } break;
    }
    return NO;
}

/**
 每次取16个,来判断
 Remove items to make the total size not larger than a specified size.
 The least recently used (LRU) items will be removed first.
 
 @param maxSize The specified size in bytes.
 @return Whether succeed.
 */
- (BOOL)removeItemsToFitSize:(int)maxSize {
    if (maxSize == INT_MAX) return YES;
    if (maxSize <= 0) return [self removeAllItems];
    
    int total = [self _dbGetTotalItemSize];
//    if (total < 0) return NO;
    if (total <= maxSize) return YES;
    
    NSArray *items = nil;
    BOOL success = NO;
    do {
        int perCount = 16;
        items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
        for (YYKVStorageItem *item in items) {
            if (total > maxSize) {
                if (item.filename) {
                    [self _fileDeleteWithName:item.filename];
                }
                success = [self _dbDeleteItemWithKey:item.key];
                total -= item.size;
            } else {
                break;
            }
            if (!success) {
                break;
            }
        }
    } while (items.count > 0);
    
    return success;
}

/**
 Remove items to make the total count not larger than a specified count.
 The least recently used (LRU) items will be removed first.
 
 @param maxCount The specified item count.
 @return Whether succeed.
 */
- (BOOL)removeItemsToFitCount:(int)maxCount {
    if (maxCount == INT_MAX) return YES;
    if (maxCount <= 0) return [self removeAllItems];
    
    int total = [self _dbGetTotalItemCount];
    //    if (total < 0) return NO;
    if (total <= maxCount) return YES;
    
    NSArray *items = nil;
    BOOL success = NO;
    do {
        int perCount = 16;
        items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
        for (YYKVStorageItem *item in items) {
            if (total > maxCount) {
                if (item.filename) {
                    [self _fileDeleteWithName:item.filename];
                }
                success = [self _dbDeleteItemWithKey:item.key];
                total --;
            } else {
                break;
            }
            if (!success) {
                break;
            }
        }
    } while (items.count > 0);
    
    return success;
}

/**
 通过后台queue直接把文件和数据库文件移到回收站
 比removeAllItemsWithProgressBlock快很多
 Remove all items in background queue.
 
 @discussion This method will remove the files and sqlite database to a trash
 folder, and then clear the folder in background queue. So this method is much
 faster than `removeAllItemsWithProgressBlock:endBlock:`.
 
 @return Whether succeed.
 */
- (BOOL)removeAllItems {
    if (![self _dbClose]) return NO;
    [self _reset];
    if (![self _dbOpen]) return NO;
    if (![self _dbInitialize]) return NO;
    return YES;
}

/**
 Remove all items.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllItemsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                               endBlock:(void(^)(BOOL error))end {
    int total = [self _dbGetTotalItemCount];
    if (total <= 0) {
        if (end) {
            end(NO);
        }
    } else {
        int leftCount = total;
        int perCount = 32;
        NSArray *items = nil;
        BOOL suc = NO;
        do {
            items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
            for (YYKVStorageItem *item in items) {
                if (leftCount > 0) {
                    if (item.filename) {
                        [self _fileDeleteWithName:item.filename];
                    }
                    suc = [self _dbDeleteItemWithKey:item.key];
                    leftCount--;
                } else {
                    break;
                }
                if (!suc) break;
            }
            if (progress) progress(total - leftCount, total);
        } while (leftCount > 0 && items.count > 0);
        if (end) end(!suc);
    }
}


#pragma mark - Get Items
///=============================================================================
/// @name Get Items
///=============================================================================

/**
 获取item完整数据
 Get item with a specified key.
 
 @param key A specified key.
 @return Item for the key, or nil if not exists / error occurs.
 */
- (YYKVStorageItem *)getItemForKey:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    YYKVStorageItem *item = [self _dbGetItemWithKey:key excludeInlineData:NO];
    if (item) {
        [self _dbUpdateAccessTimeWithKey:key];
        if (item.filename) {
            item.value = [self _fileReadWithName:item.filename];
            if (!item.value) {
                [self _dbDeleteItemWithKey:key];
                item = nil;
            }
        }
    }
    return nil;
}

/**
 只获取item的信息,忽略item.value
 Get item information with a specified key.
 The `value` in this item will be ignored.
 
 @param key A specified key.
 @return Item information for the key, or nil if not exists / error occurs.
 */
- (YYKVStorageItem *)getItemInfoForKey:(NSString *)key {
    if (key.length == 0) return nil;
    YYKVStorageItem *item = [self _dbGetItemWithKey:key excludeInlineData:YES];
    return item;
}

/**
 只获取item.value
 Get item value with a specified key.
 
 @param key  A specified key.
 @return Item's value, or nil if not exists / error occurs.
 */
- (NSData *)getItemValueForKey:(NSString *)key {
    if (key.length == 0) return nil;
    NSData *value = nil;
    switch (_type) {
        case YYKVStorageTypeFile: {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename) {
                value = [self _fileReadWithName:filename];
                if (!value) {
                    [self _dbDeleteItemWithKey:key];
                }
            }
            break;
        }
        case YYKVStorageTypeSQLite: {
            value = [self _dbGetValueWithKey:key];
            break;
        }
        case YYKVStorageTypeMixed: {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename) {
                value = [self _fileReadWithName:filename];
                if (!value) {
                    [self _dbDeleteItemWithKey:key];
                }
            } else {
                value = [self _dbGetValueWithKey:key];
            }
            break;
        }
            
        default:
            break;
    }
    if (value) {
        [self _dbUpdateAccessTimeWithKey:key];
    }
    return value;
}

/**
 Get items with an array of keys.
 
 @param keys  An array of specified keys.
 @return An array of `YYKVStorageItem`, or nil if not exists / error occurs.
 */
- (NSArray *)getItemForKeys:(NSArray *)keys {
    if (keys.count == 0) return nil;
    NSMutableArray *items = [self _dbGetItemWithKeys:keys excludeInlineData:NO];
    if (_type != YYKVStorageTypeSQLite) {
        for (NSInteger i = 0, max = items.count; i < max; i++) {
            YYKVStorageItem *item = items[i];
            if (item.filename) {
                item.value = [self _fileReadWithName:item.filename];
                if (!item.value) {
                    if (item.key) [self _dbDeleteItemWithKey:item.key];
                    [items removeObjectAtIndex:i];
                    i--;
                    max--;
                }
            }
        }
    }
    if (items.count > 0) {
        [self _dbUpdateAccessTimeWithKeys:keys];
    }
    return items.count ? items : nil;
}

/**
 Get item infomartions with an array of keys.
 The `value` in items will be ignored.
 
 @param keys  An array of specified keys.
 @return An array of `YYKVStorageItem`, or nil if not exists / error occurs.
 */
- (NSArray *)getItemInfoForKeys:(NSArray *)keys {
    if (keys.count == 0) return nil;
    return [self _dbGetItemWithKeys:keys excludeInlineData:YES];
}

/**
 Get items value with an array of keys.
 
 @param keys  An array of specified keys.
 @return A dictionary which key is 'key' and value is 'value', or nil if not
 exists / error occurs.
 */
- (NSDictionary *)getItemValueForKeys:(NSArray *)keys {
    NSMutableArray *items = (NSMutableArray *)[self getItemForKeys:keys];
    NSMutableDictionary *kv = [NSMutableDictionary new];
    for (YYKVStorageItem *item in items) {
        if (item.key && item.value) {
            [kv setObject:item.value forKey:item.key];
        }
    }
    return kv.count ? kv : nil;
}

#pragma mark - Get Storage Status

///=============================================================================
/// @name Get Storage Status
///=============================================================================

/**
 Whether an item exists for a specified key.
 
 @param key  A specified key.
 
 @return `YES` if there's an item exists for the key, `NO` if not exists or an error occurs.
 */
- (BOOL)itemExistsForKey:(NSString *)key {
    if (key.length == 0) return NO;
    return [self _dbGetItemCountWithKey:key] > 0;
}

/**
 Get total item count.
 @return Total item count, -1 when an error occurs.
 */
- (int)getItemsCount {
    return [self _dbGetTotalItemCount];
}

/**
 Get item value's total size in bytes.
 @return Total size in bytes, -1 when an error occurs.
 */
- (int)getItemsSize {
    return [self _dbGetTotalItemSize];
}

#pragma mark - Private 

/**
 Delete all files and empty in background.
 Make sure the db is closed.
 */
- (void)_reset {
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBFilename] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBShmFilename] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBWalFilename] error:nil];
    [self _fileMoveAllToTrash];
    [self _fileEmptyTrashInBackground];
}

- (void)_appWillBeTerminated {
    OSSpinLockLock(&_dbStateLock);
    _invalidated = YES;
    OSSpinLockUnlock(&_dbStateLock);
}

#pragma mark - db

- (BOOL)_dbOpen {
    BOOL shouldOpen = YES;
    OSSpinLockLock(&_dbStateLock);
    if (_invalidated || _dbIsClosing || _dbHandle) {
        shouldOpen = NO;
    }
    OSSpinLockUnlock(&_dbStateLock);
    if (!shouldOpen) {
        return NO;
    }
    
    _dbHandle = dbGetHandleWithPath(_dataPath.UTF8String);
    if (_dbHandle) {
        _dbStmtCache = [NSMutableDictionary dictionary];
        return YES;
    } else {
        debugLog(@"%s line:%d sqlite open failed.", __FUNCTION__, __LINE__);
        return NO;
    }
}

- (BOOL)_dbClose {
    BOOL needClose = YES;
    OSSpinLockLock(&_dbStateLock);
    if (_invalidated || _dbIsClosing || !_dbHandle) {
        needClose = NO;
    }
    _dbIsClosing = YES;
    OSSpinLockUnlock(&_dbStateLock);
    if (!needClose) {
        return NO;
    }
    
    if (_dbStmtCache) {
        [_dbStmtCache removeAllObjects];
        _dbStmtCache = nil;
    }
    
    dbClose(_dbHandle);
    _dbHandle = NULL;
    
    OSSpinLockLock(&_dbStateLock);
    _dbIsClosing = NO;
    OSSpinLockUnlock(&_dbStateLock);
    
    return YES;
}

- (BOOL)_dbIsReady {
    return (_dbHandle && !_dbIsClosing && !_invalidated);
}

/**
 *  开启WAL模式,创建表,索引等
 */
- (BOOL)_dbInitialize {
    NSString *sql = @"pragma journal_mode = wal; pragma synchronous = normal; create table if not exists manifest (key text, filename text, size integer, inline_data blob, modification_time integer, last_access_time integer, extended_data blob, primary key(key)); create index if not exists last_access_time_idx on manifest(last_access_time);";
    return [self _dbExecute:sql];
}

- (BOOL)_dbExecute:(NSString *)sql {
    if (sql.length == 0) return NO;
    if (![self _dbIsReady]) return NO;
    return dbExecSql(_dbHandle, sql.UTF8String) == DbScucess;
}

/**
 *  缓存sql的sqlite3_stmt(准备语句)到字典中
 */
- (sqlite3_stmt *)_dbPrepareStmt:(NSString *)sql {
    if (sql.length == 0) return nil;
    if (![self _dbIsReady]) return nil;
    
    sqlite3_stmt *stmt = (__bridge sqlite3_stmt *)(_dbStmtCache[sql]);
    if (!stmt) {
        stmt = dbPrepareSqlStmt(_dbHandle, sql.UTF8String);
        if (!stmt) {
            return NULL;
        }
        _dbStmtCache[sql] = (__bridge id _Nullable)(stmt);
    } else {
        sqlite3_reset(stmt);
    }
    return stmt;
}

/**
 *  比如数组[@"name", @"age"] 返回 ?,?
 */
- (NSString *)_dbJoinedKeys:(NSArray *)keys {
    NSMutableString *string = [NSMutableString new];
    for (NSUInteger i = 0,max = keys.count; i < max; i++) {
        [string appendString:@"?"];
        if (i + 1 != max) {
            [string appendString:@","];
        }
    }
    return string;
}

/**
 *  位置绑定
 */
- (void)_dbBindJoinedKeys:(NSArray *)keys stmt:(sqlite3_stmt *)stmt fromIndex:(int)index{
    for (int i = 0, max = (int)keys.count; i < max; i++) {
        NSString *key = keys[i];
        sqlite3_bind_text(stmt, index + i, key.UTF8String, -1, NULL);
    }
}

/**
 *  存储数据到sqltie,
 如果文件名为空,则保存value,否则不保存
 */
- (BOOL)_dbSaveWithKey:(NSString *)key value:(NSData *)value filename:(NSString *)filename extendedData:(NSData *)extendedData {
    NSString *sql = @"insert or replace into manifest (key, filename, size, inline_data, modification_time, last_access_time, extended_data) values (?1, ?2, ?3, ?4, ?5, ?6, ?7);";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    
    int timestamp = (int)time(NULL);
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, filename.UTF8String, -1, NULL);
    
    int valueLength = (int)value.length;
    sqlite3_bind_int(stmt, 3, valueLength);
    
    /**
     *  文件名为空,则保存value到sqlite
     */
    if (filename.length == 0) {
        sqlite3_bind_blob(stmt, 4, value.bytes, valueLength, NULL);
    } else {
        sqlite3_bind_blob(stmt, 4, NULL, 0, 0);
    }
    sqlite3_bind_int(stmt, 5, timestamp);
    sqlite3_bind_int(stmt, 6, timestamp);
    sqlite3_bind_blob(stmt, 7, extendedData.bytes, (int)extendedData.length, 0);
    
    NSArray *results = [self _dbOneFieldQueryWithStmt:stmt resultType:YYSqliteTypeNone];
    sqlite3_finalize(stmt);
    return results != nil;
}

/**
 *  更新指定key的访问时间
 */
- (BOOL)_dbUpdateAccessTimeWithKey:(NSString *)key {
    NSString *sql = @"update manifest set last_access_time = ?1 where key = ?2;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_int(stmt, 1, (int)time(NULL));
    sqlite3_bind_text(stmt, 2, key.UTF8String, -1, NULL);
    
    NSArray *results = [self _dbOneFieldQueryWithStmt:stmt resultType:YYSqliteTypeNone];
    return results != nil;
}

/**
 *  更新一组keys的访问时间
 */
- (BOOL)_dbUpdateAccessTimeWithKeys:(NSArray *)keys {
    if (![self _dbIsReady]) return NO;
    int t = (int)time(NULL);
    NSString *sql = [NSString stringWithFormat:@"update manifest set last_access_time = %d where key in (%@);", t, [self _dbJoinedKeys:keys]];
    
    sqlite3_stmt *stmt = dbPrepareSqlStmt(_dbHandle, sql.UTF8String);
    if (!stmt) {
        if (_errorLogsEnabled)  debugLog(@"%s line:%d sqlite stmt prepare error : %s", __FUNCTION__, __LINE__, sqlite3_errmsg(_dbHandle));
        return NO;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSArray *results = [self _dbOneFieldQueryWithStmt:stmt resultType:YYSqliteTypeNone];
    sqlite3_finalize(stmt);
    return results != nil;
}

- (BOOL)_dbDeleteItemWithKey:(NSString *)key {
    NSString *sql = @"delete from manifest where key = ?1;";
    return [self _dbOneFieldQueryWithSql:sql value:key type:YYSqliteTypeText resultType:YYSqliteTypeNone] != nil;
}

- (BOOL)_dbDeleteItemWithKeys:(NSArray *)keys {
    if (![self _dbIsReady]) return NO;
    NSString *sql =  [NSString stringWithFormat:@"delete from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    sqlite3_stmt *stmt = dbPrepareSqlStmt(_dbHandle, sql.UTF8String);
    if (!stmt) {
        if (_errorLogsEnabled)  debugLog(@"%s line:%d sqlite stmt prepare error : %s", __FUNCTION__, __LINE__, sqlite3_errmsg(_dbHandle));
        return NO;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSArray *results = [self _dbOneFieldQueryWithStmt:stmt resultType:YYSqliteTypeNone];
    sqlite3_finalize(stmt);
    return results != nil;
}

- (BOOL)_dbDeleteItemsWithSizeLargerThan:(int)size {
    NSString *sql = @"delete from manifest where size > ?1;";
    return [self _dbOneFieldQueryWithSql:sql value:@(size) type:YYSqliteTypeInt resultType:YYSqliteTypeNone] != nil;
}

- (BOOL)_dbDeleteItemsWithTimeEarlierThan:(int)time {
    NSString *sql = @"delete from manifest where last_access_time < ?1;";
    return [self _dbOneFieldQueryWithSql:sql value:@(time) type:YYSqliteTypeInt resultType:YYSqliteTypeNone] != nil;
}


/**
 *  注意:执行后不会调用 sqlite3_finalize(stmt);
 */
- (NSMutableArray *)_dbOneFieldQueryWithStmt:(sqlite3_stmt *)stmt resultType:(YYSqliteType)resultType{
    if (!stmt) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray new];
    int result = 0;
    id value;
    do {
        result = sqlite3_step(stmt);
        if (result == SQLITE_ROW) {
            value = nil;
            switch (resultType) {
                case YYSqliteTypeInt:
                    value = @(sqlite3_column_int(stmt, 0));
                    break;
                case YYSqliteTypeText: {
                    char *string = (char *)sqlite3_column_text(stmt, 0);
                    if (string && *string != 0) {
                        value = [NSString stringWithUTF8String:string];
                    }
                    break;
                }
                default:
                    break;
            }
            if (value) [results addObject:value];
        } else if (result == SQLITE_DONE) {
            break;
        } else {
            if (_errorLogsEnabled) debugLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
            results = nil;
            break;
        }
    } while (1);
    return results;
}

/**
 *  一个返回值的select查询,支持sql中添加一个参数绑定
 *
 *  @param sql        查询sql
 *  @param value      sql中的参数值
 *  @param valueType  sql中的参数值的类型
 *  @param resultType 返回值的类型
 */
- (NSMutableArray *)_dbOneFieldQueryWithSql:(NSString *)sql value:(id)value type:(YYSqliteType)valueType resultType:(YYSqliteType)resultType {
    if (!sql) {
        return nil;
    }
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    if (value) {
        switch (valueType) {
            case YYSqliteTypeInt:
                sqlite3_bind_int(stmt, 1, [value intValue]);
                break;
            case YYSqliteTypeText: {
                sqlite3_bind_text(stmt, 1, [(NSString *)value UTF8String], -1, NULL);
                break;
            }
            default:
                return nil;
                break;
        }
    }
    
    return [self _dbOneFieldQueryWithStmt:stmt resultType:resultType];
}

- (YYKVStorageItem *)_dbGetItemWithStmt:(sqlite3_stmt *)stmt excludeInlineData:(BOOL) excludeInlineData{
    int i = 0;
    char *key = (char *)sqlite3_column_text(stmt, i++);
    char *filename = (char *)sqlite3_column_text(stmt, i++);
    int size = sqlite3_column_int(stmt, i++);
    const void *inline_data = excludeInlineData ? NULL : sqlite3_column_blob(stmt, i);
    int inline_data_bytes = excludeInlineData ? 0 : sqlite3_column_bytes(stmt, i++);
    int modification_time = sqlite3_column_int(stmt, i++);
    int last_access_time = sqlite3_column_int(stmt, i++);
    const void *extended_data = sqlite3_column_blob(stmt, i);
    int extended_data_bytes = sqlite3_column_bytes(stmt, i++);
    
    YYKVStorageItem *item = [YYKVStorageItem new];
    if (key) item.key = [NSString stringWithUTF8String:key];
    if (filename && *filename != 0) item.filename = [NSString stringWithUTF8String:filename];
    item.size = size;
    if (inline_data_bytes > 0 && inline_data) item.value = [NSData dataWithBytes:inline_data length:inline_data_bytes];
    item.modTime = modification_time;
    item.accessTime = last_access_time;
    if (extended_data_bytes > 0 && extended_data) item.extendedData = [NSData dataWithBytes:extended_data length:extended_data_bytes];
    return item;
}

- (YYKVStorageItem *)_dbGetItemWithKey:(NSString *)key excludeInlineData:(BOOL)excludeInlineData {
    NSString *sql = excludeInlineData ? @"select key, filename, size, modification_time, last_access_time, extended_data from manifest where key = ?1;" : @"select key, filename, size, inline_data, modification_time, last_access_time, extended_data from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    YYKVStorageItem *item = nil;
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW) {
        item = [self _dbGetItemWithStmt:stmt excludeInlineData:excludeInlineData];
    } else {
        if (result != SQLITE_DONE) {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
        }
    }
    return item;
}

- (NSMutableArray *)_dbGetItemWithKeys:(NSArray *)keys excludeInlineData:(BOOL)excludeInlineData {
    if (![self _dbIsReady]) return nil;
    NSString *sql;
    if (excludeInlineData) {
        sql = [NSString stringWithFormat:@"select key, filename, size, modification_time, last_access_time, extended_data from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    } else {
        sql = [NSString stringWithFormat:@"select key, filename, size, inline_data, modification_time, last_access_time, extended_data from manifest where key in (%@)", [self _dbJoinedKeys:keys]];
    }
    
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_dbHandle, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
        return nil;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSMutableArray *items = [NSMutableArray new];
    do {
        result = sqlite3_step(stmt);
        if (result == SQLITE_ROW) {
            YYKVStorageItem *item = [self _dbGetItemWithStmt:stmt excludeInlineData:excludeInlineData];
            if (item) [items addObject:item];
        } else if (result == SQLITE_DONE) {
            break;
        } else {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
            items = nil;
            break;
        }
    } while (1);
    sqlite3_finalize(stmt);
    return items;
}

- (NSString *)_dbGetFilenameWithKey:(NSString *)key {
    NSString *sql = @"select filename from manifest where key = ?1;";
    NSArray *fileNames = [self _dbOneFieldQueryWithSql:sql value:key type:YYSqliteTypeText resultType:YYSqliteTypeText];
    if (fileNames.count >= 1) {
        return fileNames.firstObject;
    }
    return nil;
}

- (NSData *)_dbGetValueWithKey:(NSString *)key {
    NSString *sql = @"select inline_data from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result == SQLITE_DONE) {
        const void *inlineData = sqlite3_column_blob(stmt, 0);
        int inlineDataBytes = sqlite3_column_bytes(stmt, 0);
        if (!inlineData || inlineDataBytes <= 0) return nil;
        return [NSData dataWithBytes:inlineData length:inlineDataBytes];
    } else {
        if (result != SQLITE_DONE) {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
        }
        return nil;
    }
}

- (NSMutableArray *)_dbGetFilenameWithKeys:(NSArray *)keys {
    if (![self _dbIsReady]) return nil;
    NSString *sql = [NSString stringWithFormat:@"select filename from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    sqlite3_stmt *stmt = dbPrepareSqlStmt(_dbHandle, sql.UTF8String);
    if (!stmt) {
        if (_errorLogsEnabled) debugLog(@"%s line:%d sqlite stmt prepare error : %s", __FUNCTION__, __LINE__, sqlite3_errmsg(_dbHandle));
        return nil;
    }
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSMutableArray *filenames = [self _dbOneFieldQueryWithStmt:stmt resultType:YYSqliteTypeText];
    sqlite3_finalize(stmt);
    return filenames;
}

- (NSMutableArray *)_dbGetFilenamesWithSizeLargerThan:(int)size {
    NSString *sql = @"select filename from manifest where size > ?1 and filename is not null;";
    return [self _dbOneFieldQueryWithSql:sql value:@(size) type:YYSqliteTypeInt resultType:YYSqliteTypeText];
}

- (NSMutableArray *)_dbGetFilenamesWithTimeEarlierThan:(int)time {
    NSString *sql = @"select filename from manifest where last_access_time < ?1 and filename is not null;";
    return [self _dbOneFieldQueryWithSql:sql value:@(time) type:YYSqliteTypeInt resultType:YYSqliteTypeText];
}

- (NSMutableArray *)_dbGetItemSizeInfoOrderByTimeDescWithLimit:(int)count {
    NSString *sql = @"select key, filename, size from manifest order by last_access_time desc limit ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    NSMutableArray *items = [NSMutableArray new];
    do {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_ROW) {
            char *key = (char *)sqlite3_column_text(stmt, 0);
            char *filename = (char *)sqlite3_column_text(stmt, 1);
            int size = sqlite3_column_int(stmt, 2);
            YYKVStorageItem *item = [YYKVStorageItem new];
            item.key = key ? [NSString stringWithUTF8String:key] : nil;
            item.filename = filename ? [NSString stringWithUTF8String:filename] : nil;
            item.size = size;
            [items addObject:item];
        } else if (result == SQLITE_DONE) {
            break;
        } else {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_dbHandle));
            items = nil;
            break;
        }
    } while (1);
    return items;
}

- (int)_dbGetItemCountWithKey:(NSString *)key {
    NSString *sql = @"select count(key) from manifest where key = ?1;";
    NSArray *results = [self _dbOneFieldQueryWithSql:sql value:key type:YYSqliteTypeText resultType:YYSqliteTypeInt];
    if (results.count > 0) {
        return [results.firstObject intValue];
    }
    return -1;
}

- (int)_dbGetTotalItemSize {
    NSString *sql = @"select sum(size) from manifest;";
    NSArray *results = [self _dbOneFieldQueryWithSql:sql value:nil type:0 resultType:YYSqliteTypeInt];
    if (results.count >= 1) {
        return [results.firstObject intValue];
    }
    return -1;
}

- (int)_dbGetTotalItemCount {
    NSString *sql = @"select count(*) from manifest;";
    NSArray *results = [self _dbOneFieldQueryWithSql:sql value:nil type:0 resultType:YYSqliteTypeInt];
    if (results.count >= 1) {
        return [results.firstObject intValue];
    }
    return -1;
}

#pragma mark - file

/**
 *  将数据保存到一个文本文件里
 */
- (BOOL)_fileWriteWithName:(NSString *)filename data:(NSData *)data {
    if (_invalidated) {
        return NO;
    }
    return [data writeToFile:[_dataPath stringByAppendingPathComponent:filename] atomically:NO];
}

- (NSData *)_fileReadWithName:(NSString *)filename {
    if (_invalidated) return nil;
    NSString *path = [_dataPath stringByAppendingPathComponent:filename];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (BOOL)_fileDeleteWithName:(NSString *)filename {
    if (_invalidated) return NO;
    NSString *path = [_dataPath stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

/**
 *  将所有文件移动到回收站中,
 _dataPath/目录下的所有文件都移动到了_trashPath/uuid/ 目录下/
 */
- (BOOL)_fileMoveAllToTrash {
    if (_invalidated) return NO;
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *tmpPath = [_trashPath stringByAppendingPathComponent:(__bridge NSString *)(uuid)];
    BOOL suc = [[NSFileManager defaultManager] moveItemAtPath:_dataPath toPath:tmpPath error:nil];
    if (suc) {
        suc = [[NSFileManager defaultManager] createDirectoryAtPath:_dataPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    CFRelease(uuid);
    return suc;
}

/**
 *  后台异步清空回收站中的文件
 */
- (void)_fileEmptyTrashInBackground {
    if (_invalidated) return;
    NSString *trashPath = _trashPath;
    dispatch_queue_t queue = _trashQueue;
    dispatch_async(queue, ^{
        NSFileManager *manager = [NSFileManager new];
        NSArray *filenames = [manager contentsOfDirectoryAtPath:trashPath error:NULL];
        for (NSString *filename in filenames) {
            NSString *fullPath = [trashPath stringByAppendingPathComponent:filename];
            [manager removeItemAtPath:fullPath error:NULL];
        }
    });
}

@end





























