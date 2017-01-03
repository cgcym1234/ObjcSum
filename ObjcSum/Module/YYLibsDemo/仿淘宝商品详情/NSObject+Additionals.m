//
//  NSObject+Utility.m
//  DGUtilityKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import "NSObject+Additionals.h"

@implementation NSObject (ValidObject)

- (NSString *)validString
{
    id result = nil;
    
    if(self && ![self isKindOfClass:[NSNull class]])
    {
        result = [NSString stringWithFormat:@"%@", self];
    }
    
    return result;
}

- (NSArray *)validArray
{
    id result = nil;
    
    if([self isKindOfClass:[NSArray class]])
    {
        result = self;
    }
    
    return result;
}

- (NSDictionary *)validDictionary
{
    id result = nil;
    
    if([self isKindOfClass:[NSDictionary class]])
    {
        result = self;
    }
    
    return result;
}

- (NSURL *)validURL
{
    id result = nil;
    
    NSString *validString = [self validString];
    if(validString)
    {
        result = [NSURL URLWithString:validString];
    }
    
    return result;
}

@end

@implementation NSDictionary (ValidObject)

- (NSNumber *)validNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSNumber class]])
    {
        if([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [formatter numberFromString:object];
            if(number)
            {
                return number;
            }
            else
            {
                return defaultValue;
            }
        }
        
        return defaultValue;
    }
    
    return object;
}

- (NSNumber *)validNumberForKey:(NSString *)key
{
    return [self validNumberForKey:key defaultValue:nil];
}

- (NSString *)validStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSString class]])
    {
        if([object isKindOfClass:[NSNumber class]])
        {
            return [object stringValue];
        }
        
        return defaultValue;
    }
    
    return object;
}

- (NSString *)validStringForKey:(NSString *)key;
{
    return [self validStringForKey:key defaultValue:nil];
}

- (NSArray *)validArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
{
    if(!key)
    {
        return defaultValue;
    }
    
    id array = [self objectForKey:key];
    if(![array isKindOfClass:[NSArray class]])
    {
        return defaultValue;
    }
    
    return array;
}

- (NSArray *)validArrayForKey:(NSString *)key;
{
    return [self validArrayForKey:key defaultValue:nil];
}

- (NSDictionary *)validDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    if(!key)
    {
        return defaultValue;
    }
    
    id object = [self objectForKey:key];
    if(![object isKindOfClass:[NSDictionary class]])
    {
        return defaultValue;
    }
    
    return object;
}

- (NSDictionary *)validDictionaryForKey:(NSString *)key
{
    return [self validDictionaryForKey:key defaultValue:nil];
}

@end

@implementation NSArray (ValidObject)

- (NSNumber *)validNumberAtIndex:(NSInteger)index defaultValue:(NSNumber *)defaultValue
{
    id object = [self safeObjectAtIndex:index];
    if(![object isKindOfClass:[NSNumber class]])
    {
        if([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [formatter numberFromString:object];
            if(number)
            {
                return number;
            }
            else
            {
                return defaultValue;
            }
        }
        
        return defaultValue;
    }
    
    return object;
}

- (NSNumber *)validNumberAtIndex:(NSInteger)index
{
    return [self validNumberAtIndex:index defaultValue:nil];
}

- (NSString *)validStringAtIndex:(NSInteger)index defaultValue:(NSString *)defaultValue
{
    id object = [self safeObjectAtIndex:index];
    if(![object isKindOfClass:[NSString class]])
    {
        if([object isKindOfClass:[NSNumber class]])
        {
            return [object stringValue];
        }
        
        return defaultValue;
    }
    
    return object;
}

- (NSString *)validStringAtIndex:(NSInteger)index
{
    return [self validStringAtIndex:index defaultValue:nil];
}

- (NSArray *)validArrayAtIndex:(NSInteger)index defaultValue:(NSArray *)defaultValue
{
    id array = [self safeObjectAtIndex:index];
    if(![array isKindOfClass:[NSArray class]])
    {
        return defaultValue;
    }
    
    return array;
}

- (NSArray *)validArrayAtIndex:(NSInteger)index
{
    return [self validArrayAtIndex:index defaultValue:nil];
}

- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index defaultValue:(NSDictionary *)defaultValue
{
    id object = [self safeObjectAtIndex:index];
    if(![object isKindOfClass:[NSDictionary class]])
    {
        return defaultValue;
    }
    
    return object;
}

- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index
{
    return [self validDictionaryAtIndex:index defaultValue:nil];
}

@end

@implementation NSMutableDictionary (SafeObject)

- (void)setSafeObject:(id)object forKey:(id<NSCopying>)key
{
    if(object && key)
    {
        [self setObject:object forKey:key];
    }
}

@end

@implementation NSMutableArray (SafeObject)

- (void)addSafeObject:(id)object
{
    if(object)
    {
        [self addObject:object];
    }
}

@end

@implementation NSArray (SafeObject)

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index >= 0 && index < [self count])
    {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

@end
