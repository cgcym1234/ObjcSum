//
//  YYKeyValueStore.h
//  ObjcSum
//
//  Created by sihuan on 15/11/19.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYKeyValueItem: NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) NSDate *createdTime;
@property (nonatomic, strong) id itemObject;

@end

@interface YYKeyValueStore : NSObject

/**
 *  在程序的`Document`目录打开指定的数据库文件。如果该文件不存在，则会创建一个新的数据库。
 *
 *  @param dbName 数据库名字
 *
 *  @return 数据库对象
 */
- (instancetype)initWithDBName:(NSString *)dbName;

/**
 *  打开指定路径的数据库文件。如果该文件不存在，则会创建一个新的数据库。
 *
 *  @param dbPath 数据库文件路径
 *
 *  @return 数据库对象
 */
- (instancetype)initWithDBPath:(NSString *)dbPath;

/**
 *  在打开的数据库中创建表，如果表名已经存在，则会忽略该操作。
 *
 *  @param tableName 表名
 *
 *  @return 是否创建成功
 */
- (BOOL)createTableWithName:(NSString *)tableName;

/**
 *  判读在打开的数据库中是否已经存在一个表
 *
 *  @param tableName 表名
 *
 *  @return 是否存在
 */
- (BOOL)isTableExists:(NSString *)tableName;

/**
 *  清空表
 */
- (BOOL)truncateTable:(NSString *)tableName;
- (BOOL)deleteTable:(NSString *)tableName;
- (void)close;



/**
 *  向表中插入一条数据
 存入的所有数据需要提供key以及其对应的value，读取的时候需要提供key来获得相应的value。
 支持的value类型包括：NSString, NSNumber, NSDictionary和NSArray 这些可以转换成json的数据
 *
 *  @param object    必须是可以转换成json的数据
 *  @param key       存储该数据的key
 *  @param tableName 表名
 */
- (BOOL)setObject:(id)object forKey:(NSString *)key intoTable:(NSString *)tableName;




@end
