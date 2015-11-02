//
//  NSObject+Property.h
//   
//
//
//
//

/**
 *  通过运行时机制,取得NSObject的属性，并存入到数组中

 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Property)

//通过运行时机制取得NSObject的属性，并存入到数组中
- (NSArray *)getPropertyList;
- (NSArray *)getPropertyList:(Class)clazz;

//根据属性生成创建Sqlite表的语句
- (NSString *)tableSql:(NSString *)tablename;
- (NSString *)tableSql;

//把一个实体对象，封装成字典Dictionary
- (NSDictionary *)convertToDictionary;

//通过遍历dict的key，将其value赋值给object对象中对应的属性
- (id)initWithDictionary:(NSDictionary *)dict;

//返回一个对象的类型名称
- (NSString *)className;
@end
