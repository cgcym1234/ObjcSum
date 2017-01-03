//
//  NSArray+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSArray+YYExtension.h"
#import "NSData+YYExtension.h"

@implementation NSArray (YYExtension)

#pragma mark - Plist
/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */

+ (NSArray *)yy_arrayWithPlistData:(NSData *)plist {
    if (!plist) {
        return nil;
    }
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return nil;
}

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSArray *)yy_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yy_arrayWithPlistData:data];
}

/**
 Serialize the array to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 */
- (NSData *)yy_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)yy_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) {
        return [xmlData utf8String];
    }
    return nil;
}

#pragma mark - Json

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (NSString *)yy_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (!error) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return nil;
}

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (NSString *)yy_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return nil;

}

#pragma mark - Utility

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (id)yy_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (id)yy_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}


@end

#pragma mark - NSMutableArray

/**
 Provide some some common method for `NSMutableArray`.
 */
@implementation NSMutableArray (YYExtension)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (NSMutableArray *)yy_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSMutableArray *)yy_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yy_arrayWithPlistData:data];
}

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)yy_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
- (void)yy_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)yy_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self yy_removeFirstObject];
    }
    return obj;
}

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)yy_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)yy_appendObject:(id)anObject {
    [self addObject:anObject];
}

/**
 Inserts a given object at the beginning of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)yy_prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)yy_appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)yy_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)yy_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)yy_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

/**
 Sort the object in this array randomly.
 */
- (void)yy_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

-(void)safe_addObject:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}

-(id)safe_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}
@end



