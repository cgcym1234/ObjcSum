//
//  NSDictionary+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YYExtension)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (NSDictionary *)yy_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSDictionary *)yy_dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (NSData *)yy_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)yy_plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)yy_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)yy_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)yy_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)yy_entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (NSString *)yy_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (NSString *)yy_jsonPrettyStringEncoded;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (NSDictionary *)yy_dictionaryWithXML:(id)xmlDataOrString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)yy_boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)yy_charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)yy_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)yy_shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)yy_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)yy_intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)yy_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)yy_longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)yy_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)yy_longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)yy_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)yy_floatValueForKey:(NSString *)key default:(float)def;
- (double)yy_doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)yy_integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)yy_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (NSNumber *)yy_numverValueForKey:(NSString *)key default:(NSNumber *)def;
- (NSString *)yy_stringValueForKey:(NSString *)key default:(NSString *)def;

@end

#pragma mark - NSMutableDictionary

/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (YYExtension)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSMutableDictionary *)yy_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (NSMutableDictionary *)yy_dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (id)yy_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)yy_popEntriesForKeys:(NSArray *)keys;

@end
