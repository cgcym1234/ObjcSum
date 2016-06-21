//
//  YYKeyValueStore.m
//  ObjcSum
//
//  Created by sihuan on 15/11/19.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYKeyValueStore.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define PathDocument    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString *const DEFAULT_DB_NAME = @"database.sqlite";

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";

static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";

static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";

static NSString *const COUNT_ALL_SQL = @"SELECT count(*) as num from %@";

static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";

static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";

static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";


@implementation YYKeyValueItem

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, value=%@, timeStamp=%@", _itemId, _itemObject, _createdTime];
}

+ (instancetype)itemWithId:(NSString *)itemId object:(NSString *)object createdTime:(NSDate *)createdTime {
    YYKeyValueItem * item = [[YYKeyValueItem alloc] init];
    item.itemId = itemId;
    item.itemObject = object;
    item.createdTime = createdTime;
    return item;
}


@end

@interface YYKeyValueStore ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation YYKeyValueStore

+ (BOOL)isTableNameValid:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

/**
 *  在程序的`Document`目录打开指定的数据库文件。如果该文件不存在，则会创建一个新的数据库。
 *
 *  @param dbName 数据库名字
 *
 *  @return 数据库对象
 */
- (instancetype)initWithDBName:(NSString *)dbName {
    NSString *dbPath = [PathDocument stringByAppendingPathComponent:dbName];
    return [self initWithDBPath:dbPath];
}

/**
 *  打开指定路径的数据库文件。如果该文件不存在，则会创建一个新的数据库。
 *
 *  @param dbPath 数据库文件路径
 *
 *  @return 数据库对象
 */
- (instancetype)initWithDBPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

/**
 *  在打开的数据库中创建表，如果表名已经存在，则会忽略该操作。
 *
 *  @param tableName 表名
 *
 *  @return 是否创建成功
 */
- (BOOL)createTableWithName:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
    
    return result;
}

/**
 *  判读在打开的数据库中是否已经存在一个表
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
- (BOOL)isTableExists:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    if (!result) {
        debugLog(@"ERROR, table: %@ not exists in current DB", tableName);
    }
    return result;
}

- (BOOL)truncateTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
    
    return result;
}

- (BOOL)deleteTable:(NSString *)tableName {
    return [self truncateTable:tableName];
}

- (void)close {
    [_dbQueue close];
    _dbQueue = nil;
}

- (BOOL)setObject:(id)object forKey:(NSString *)key intoTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    
    NSError *error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        debugLog(@"ERROR, faild to get json data %@", object);
        return NO;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDate *createTime = [NSDate date];
    NSString *sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, key, jsonString, createTime];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
    return result;
}

- (id)getObjectForKey:(NSString *)key fromTable:(NSString *)tableName {
    YYKeyValueItem *item = [self getItemForKey:key fromTable:tableName];
    return item != nil ? item.itemObject : nil;
}

- (YYKeyValueItem *)getItemForKey:(NSString *)key fromTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return nil;
    }
    
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
    __block NSString *json = nil;
    __block NSDate *createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, tableName];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
            createdTime = [rs dateForColumn:@"createTime"];
        }
        [rs close];
    }];
    
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json %@", json);
            return nil;
        }
        
        YYKeyValueItem *item = [YYKeyValueItem itemWithId:key object:result createdTime:createdTime];
        return item;
    } else {
        return nil;
    }
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key intoTable:(NSString *)tableName {
    if (string == nil) {
        debugLog(@"error, string is nil");
        return NO;
    }
    return [self setObject:@[string] forKey:key intoTable:tableName];
}

- (NSString *)getStringForKey:(NSString *)key fromTable:(NSString *)tableName {
    NSArray *array = [self getObjectForKey:key fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (BOOL)setNumber:(NSNumber *)number forKey:(NSString *)key intoTable:(NSString *)tableName {
    if (number == nil) {
        debugLog(@"error, number is nil");
        return NO;
    }
    return [self setObject:@[number] forKey:key intoTable:tableName];
}

- (NSNumber *)getNumberForKey:(NSString *)key fromTable:(NSString *)tableName {
    NSArray *array = [self getObjectForKey:key fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (NSArray *)getAllItemsFromTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return nil;
    }
    NSString * sql = [NSString stringWithFormat:SELECT_ALL_SQL, tableName];
    __block NSError * error;
    __block NSMutableArray * result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            YYKeyValueItem * item = [YYKeyValueItem itemWithId:[rs stringForColumn:@"id"] object:[rs stringForColumn:@"json"] createdTime:[rs dateForColumn:@"createdTime"]];
            
            // parse json string to object
            id object = [NSJSONSerialization JSONObjectWithData:[item.itemObject dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:(NSJSONReadingAllowFragments) error:&error];
            if (error) {
                debugLog(@"ERROR, faild to prase to json. %@", item.itemObject);
            } else {
                item.itemObject = object;
            }
            [result addObject:item];
        }
        [rs close];
    }];
    

    return result;
}

- (NSUInteger)getCountFromTable:(NSString *)tableName
{
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return 0;
    }

    NSString * sql = [NSString stringWithFormat:COUNT_ALL_SQL, tableName];
    __block NSInteger num = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            num = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return num;
}

- (BOOL)deleteObjectWithKey:(NSString *)key fromTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    NSString * sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, key];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete item from table: %@", tableName);
    }
    return result;
}

- (BOOL)deleteObjectsWithKeys:(NSArray *)keys fromTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id objectId in keys) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        if (stringBuilder.length == 0) {
            [stringBuilder appendString:item];
        } else {
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by ids from table: %@", tableName);
    }

    return result;
}

- (BOOL)deleteObjectsWithKeyPrefix:(NSString *)keyPrefix fromTable:(NSString *)tableName {
    if (![YYKeyValueStore isTableNameValid:tableName]) {
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName];
    NSString *prefixArgument = [NSString stringWithFormat:@"%@%%", keyPrefix];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, prefixArgument];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by id prefix from table: %@", tableName);
    }
    return result;
}













@end
