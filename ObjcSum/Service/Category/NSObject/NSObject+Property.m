//
//  NSObject+Property.m
//   
//
//  Created on 12-12-15.
//
//

#import "NSObject+Property.h"


@implementation NSObject (Property)

 
- (NSArray *)getPropertyList{
    return [self getPropertyList:[self class]];
}

- (NSArray *)getPropertyList: (Class)clazz
{
    u_int count;
    objc_property_t *properties  = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertyArray;
}

- (NSString *)tableSql:(NSString *)tablename{
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"create table %@ (", tablename];
    
    NSArray *propertyNames = [self getPropertyList];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [sql appendFormat:@"%@ text", name];
        } else {
            [sql appendFormat:@", %@ text", name];
        }
    }];
    
    [sql appendString:@")"];
    return sql;
}
- (NSString *)tableSql{
    return [self tableSql:[self className]];
}
 

- (NSDictionary *)convertToDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyList = [self getPropertyList];
    
    [propertyList enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        id value = [self valueForKey:propertyName];
        if (value == nil) {
            value = [NSNull null];
        }
        [dict setObject:value forKey:propertyName];
    }];
    
    return dict;
}
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [self init];
    if(self)
        [self dictionaryForObject:dict];
    return self;
    
}
- (NSString *)className{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

- (BOOL)checkPropertyName:(NSString *)name {
    unsigned int propCount, i;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if(propName) {
            NSString *_name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            if ([name isEqualToString:_name]) {
                return YES;
            }
        }
    }
    return NO;
}


//从一个字典中还原成一个实体对象
- (void)dictionaryForObject:(NSDictionary*) dict{
    for (NSString *key in [dict allKeys]) {
        id value = [dict objectForKey:key];
        
        if (value==[NSNull null]) {
            continue;
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            id subObj = [self valueForKey:key];
            if (subObj)
                [subObj dictionaryForObject:value];
        }
        else{
             [self setValue:value forKeyPath:key];
        }
    }
}

@end
