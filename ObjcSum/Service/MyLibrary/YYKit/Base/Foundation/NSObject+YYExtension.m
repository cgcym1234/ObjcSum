//
//  NSObject+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSObject+YYExtension.h"
#import "YYKitMacro.h"
#import <objc/objc.h>
#import <objc/runtime.h>

static const int YY_KeyBlock;

@interface YYKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation YYKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (!_block) {
        return;
    }
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) {
        return;
    }
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) {
        oldVal = nil;
    }
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) {
        newVal = nil;
    }
    
    _block(object, oldVal, newVal);
}

@end

@implementation NSObject (YYExtension)

#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)yy_swizzleInstanceMethod:(SEL)originalSel withNew:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    
    class_addMethod(self, originalSel, class_getMethodImplementation(self, originalSel), method_getTypeEncoding(originalMethod));
    class_addMethod(self, newSel, class_getMethodImplementation(self, newSel), method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel), class_getInstanceMethod(self, newSel));
    return YES;
}

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)yy_swizzleClassMethod:(SEL)originalSel withNew:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================


/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)yy_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)yy_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (id)yy_getAssociatedValueForKey:(void *)key {
   return objc_getAssociatedObject(self, key);
}

/**
 Remove all associated values.
 */
- (void)yy_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Returns the class name in NSString.
 */
+ (NSString *)yy_className {
    return NSStringFromClass(self);
}

/**
 Returns the class name in NSString.
 
 @discussion Apple has implemented this method in NSObject(NSLayoutConstraintCallsThis),
 but did not make it public.
 */
- (NSString *)yy_className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

/**
 Returns a copy of the instance with `NSKeyedArchiver` and ``NSKeyedUnarchiver``.
 Returns nil if an error occurs.
 */
- (id)yy_deepCopy {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    return obj;
}

/**
 Returns a copy of the instance use archiver and unarchiver.
 Returns nil if an error occurs.
 
 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (id)yy_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver {
    id obj = nil;
    @try {
        obj = [unarchiver unarchiveObjectWithData:[archiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    return obj;

}

/**
 *  通过运行时机制取得对象的属性(property)，并存入到数组中
 */
- (NSArray *)yy_arrayWithProperties {
    return [NSObject yy_arrayWithPropertiesFromClass:self.class];
}

+ (NSArray *)yy_arrayWithPropertiesFromClass:(Class)clazz {
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

/**
 *  把一个实体对象，封装成字典Dictionary
 key为property名字,value为该property的取值
 */
- (NSDictionary *)yy_dictionaryWithProperties {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyList = [self yy_arrayWithProperties];
    
    [propertyList enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        id value = [self valueForKey:propertyName];
        if (value == nil) {
            value = [NSNull null];
        } else {
            [dict setObject:value forKey:propertyName];
        }
        
    }];
    
    return dict;
}

/**
 *  根据类名来实例化对象
 */
+ (id)yy_instanceFromClassName:(NSString *)clsName {
    Class cls = NSClassFromString(clsName);
    if (cls) {
        return [[cls alloc] init];
    }
    return nil;
}

#pragma mark - KVO

/**
 Registers a block to receive KVO notifications for the specified key-path
 relative to the receiver.
 
 @discussion The block and block captured objects are retained. Call
 `removeObserverBlocksForKeyPath:` or `removeObserverBlocks` to release.
 
 @param keyPath The key path, relative to the receiver, of the property to
 observe. This value must not be nil.
 
 @param block   The block to register for KVO notifications.
 */
- (void)yy_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) {
        return;
    }
    
    YYKVOBlockTarget *target = [[YYKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *targetsDict = [self yy_allObserverBlocks];
    NSMutableArray *targets = targetsDict[keyPath];
    if (!targets) {
        targets = [NSMutableArray new];
        targetsDict[keyPath] = targets;
    }
    [targets addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications for the property specified by a given key-path
 relative to the receiver, and release these blocks.
 
 @param keyPath A key-path, relative to the receiver, for which blocks is
 registered to receive KVO change notifications.
 */
- (void)yy_removeObserverBlocksForKeyPath:(NSString*)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *targetsDict = [self yy_allObserverBlocks];
    NSMutableArray *targets = targetsDict[keyPath];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    //把targets数组和里面的target释放掉,
    [targetsDict removeObjectForKey:keyPath];
}

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications, and release these blocks.
 */
- (void)yy_removeObserverBlocks {
    NSMutableDictionary *targetsDict = [self yy_allObserverBlocks];
    [targetsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull keyPath, NSArray*  _Nonnull targets, BOOL * _Nonnull stop) {
        [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:keyPath];
        }];
    }];
    
    [targetsDict removeAllObjects];
}

- (NSMutableDictionary *)yy_allObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &YY_KeyBlock);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &YY_KeyBlock, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}




@end



