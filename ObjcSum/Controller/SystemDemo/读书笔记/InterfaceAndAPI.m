//
//  InterfaceAndAPI.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "InterfaceAndAPI.h"

@interface InterfaceAndAPI ()<NSCopying, NSMutableCopying>

#pragma mark - 18 尽量使用不可变对象

/**
 *  key，value，这2个属性在内部又可以修改，使用readwrite
 */
@property (nonatomic, strong, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) NSString *value;

@end

@implementation InterfaceAndAPI {
    NSMutableArray *_keys;
}

- (instancetype)init {
    return [self initWithKey:nil value:nil];
}

#pragma mark - 第 16 条:提供"全能初始化方法"
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value {
    return [super init];
}

#pragma mark - 第 17 条:实现description方法

/**
 *  1.可以打印出类的名字和指针地址
 *  2.要打印的属性用字典方式呈现
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>",
            [self class],
            self,
            @{
              @"key":_key,
              @"value":_value,
              }];
}

#pragma mark debugDescription提供更详解的信息

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, %@>",
            [self class],
            self,
            @{
              @"key":_key,
              @"value":_value,
              }];
}

- (NSArray *)keys {
    return _keys;
}
- (void)addKey:(NSString *)key {
    [_keys addObject:key];
}
- (void)removeKey:(NSString *)key {
    [_keys removeObject:key];
}


#pragma mark - 第 20 条:为私有方法名加前缀

/**
 *  - 可以给私有方法名加前缀，很容易用同公共方法区分开
 - 不要单用一个下划线做私有方法前缀，因为苹果公司采用了这种做法，可能造成覆盖。
 */
- (void)__private {
    
}

#pragma mark - 第 21 条:理解Objective-C错误模型

/**
 *  注意，自动引用计数默认情况下不是"异常安全的(exception safe)"，如果抛出异常，那本该在作用域末尾释放的对象却不会自动释放了。
 
 要生成异常安全的代码，可以通过设置编译器的标志来实现，并且要引入一些额外代码（即使不抛异常也要执行），标志叫-fobjc-arc-exceptions
 
 所有异常需慎用，应该只用于严重错误(fetal error)，其他情况一般使用返回nil或NSError。
 */

#pragma mark - 22 理解NSCopying协议

/**
 *  自定义的类想要支持copy，需要实现NSCoping协议
 *
 *  这里为何会出现NSZone？
 
 因为以前开发程序，会据此把内存分成不同的区"zone"，而对象会创建在某个区里面，
 但现在不用了，每个程序只有一个区："默认区(default zone)"，所以只需实现该方法，而不用管zone。
 */
- (id)copyWithZone:(NSZone *)zone {
    return nil;
}

/**
 *  另外还有个NSMutableCopying协议，与NSCoping类似，NSObject在调用mutableCopy时，
 以"默认区"为参数来调用"mutableCopyWithZone:"
 */
- (id)mutableCopyWithZone:(NSZone *)zone {
    return nil;
}

#pragma mark - NSObject的copy方法
/**
 *  copy方法由NSObject实现，但它只是以"默认区"为参数来调用"copyWithZone:"。
 所以我们需要实现copyWithZone:。而不是覆盖copy方法
 *
 */
- (id)copy {
    //大约是这样
    return [self copyWithZone:NSDefaultMallocZone()];
}

/**
 *  在写copy方法时，还有一个问题：应该使用"深拷贝deep copy"还是"浅拷贝shallow copy"。
 
 - 深拷贝：在拷贝对象本身时，将其底层数据也一并复制
 - 浅拷贝：只拷贝对象本身
 
 Foundation框架中所有集合类型在默认情况下都是浅拷贝：只拷贝容器对象本身，而不复制其中的数据。
 
 如果需要深拷贝，可以提供一个专用的方法
 */
@end



















