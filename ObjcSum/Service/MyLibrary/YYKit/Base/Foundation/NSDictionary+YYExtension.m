//
//  NSDictionary+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSDictionary+YYExtension.h"
#import "NSData+YYExtension.h"
#import "NSString+YYExtension.h"

@interface YYXmlDictionaryParser : NSObject <NSXMLParserDelegate>

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithString:(NSString *)xml;
- (NSDictionary *)result;

@end

@implementation YYXmlDictionaryParser {
    NSMutableDictionary *_root;
    NSMutableArray *_stack;
    NSMutableString *_text;
}

- (instancetype)initWithData:(NSData *)data {
    self = super.init;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    return self;
}

- (instancetype)initWithString:(NSString *)xml {
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data];
}

- (NSDictionary *)result {
    return _root;
}

#pragma mark NSXMLParserDelegate

#define XMLText @"_text"
#define XMLName @"_name"
#define XMLPref @"_"

- (void)textEnd {
    _text = _text.yy_stringByTrim.mutableCopy;
    if (_text.length) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[XMLText];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:_text];
        } else if (existing) {
            top[XMLText] = [@[existing, _text] mutableCopy];
        } else {
            top[XMLText] = _text;
        }
    }
    _text = nil;
}

- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self textEnd];
    
    NSMutableDictionary *node = [NSMutableDictionary new];
    if (!_root) node[XMLName] = elementName;
    if (attributeDict.count) [node addEntriesFromDictionary:attributeDict];
    
    if (_root) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:node];
        } else if (existing) {
            top[elementName] = [@[existing, node] mutableCopy];
        } else {
            top[elementName] = node;
        }
        [_stack addObject:node];
    } else {
        _root = node;
        _stack = [NSMutableArray arrayWithObject:node];
    }
}

- (void)parser:(__unused NSXMLParser *)parser didEndElement:(__unused NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName {
    [self textEnd];
    
    NSMutableDictionary *top = _stack.lastObject;
    [_stack removeLastObject];
    
    NSMutableDictionary *left = top.mutableCopy;
    [left removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in left.allKeys) {
        [left removeObjectForKey:key];
        if ([key hasPrefix:XMLPref]) {
            left[[key substringFromIndex:XMLPref.length]] = top[key];
        }
    }
    if (left.count) return;
    
    NSMutableDictionary *children = top.mutableCopy;
    [children removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in children.allKeys) {
        if ([key hasPrefix:XMLPref]) {
            [children removeObjectForKey:key];
        }
    }
    if (children.count) return;
    
    NSMutableDictionary *topNew = _stack.lastObject;
    NSString *nodeName = top[XMLName];
    if (!nodeName) {
        for (NSString *name in topNew) {
            id object = topNew[name];
            if (object == top) {
                nodeName = name; break;
            } else if ([object isKindOfClass:[NSArray class]] && [object containsObject:top]) {
                nodeName = name; break;
            }
        }
    }
    if (!nodeName) return;
    
    id inner = top[XMLText];
    if ([inner isKindOfClass:[NSArray class]]) {
        inner = [inner componentsJoinedByString:@"\n"];
    }
    if (!inner) return;
    
    id parent = topNew[nodeName];
    if ([parent isKindOfClass:[NSArray class]]) {
        parent[[parent count] - 1] = inner;
    } else {
        topNew[nodeName] = inner;
    }
}

- (void)parser:(__unused NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

- (void)parser:(__unused NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

#undef XMLText
#undef XMLName
#undef XMLPref

@end



@implementation NSDictionary (YYExtension)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (NSDictionary *)yy_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSDictionary *)yy_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yy_dictionaryWithPlistData:data];
}

/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (NSData *)yy_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)yy_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)yy_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)yy_allValuesSortedByKeys {
    NSArray *sortedKeys = [self yy_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)yy_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)yy_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
}

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (NSString *)yy_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (jsonData) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    
    return nil;
}

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (NSString *)yy_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return nil;
}

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (NSDictionary *)yy_dictionaryWithXML:(id)xmlDataOrString {
    YYXmlDictionaryParser *parser = nil;
    if ([xmlDataOrString isKindOfClass:[NSString class]]) {
        parser = [[YYXmlDictionaryParser alloc] initWithString:xmlDataOrString];
    } else if ([xmlDataOrString isKindOfClass:[NSData class]]) {
        parser = [[YYXmlDictionaryParser alloc] initWithData:xmlDataOrString];
    }
    return [parser result];
}

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

#define YYReturnValue(_type_)   \
if (key) {                      \
id value = self[key];   \
if (value) {    \
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) { \
        return [value _type_];   \
    }   \
}   \
}   \
return def;

- (BOOL)yy_boolValueForKey:(NSString *)key default:(BOOL)def {
    YYReturnValue(boolValue);
//    if (key) {
//        id value = self[key];
//        if (value) {
//            if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
//                return [value boolValue];
//            }
//        }
//    }
//    return def;
}

- (char)yy_charValueForKey:(NSString *)key default:(char)def {
    YYReturnValue(charValue);
}

- (unsigned char)yy_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def {
    YYReturnValue(unsignedCharValue);
}

- (short)yy_shortValueForKey:(NSString *)key default:(short)def {
    YYReturnValue(shortValue);
}
- (unsigned short)yy_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def {
    YYReturnValue(unsignedShortValue);
}

- (int)yy_intValueForKey:(NSString *)key default:(int)def {
    YYReturnValue(intValue);
}
- (unsigned int)yy_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def {
    YYReturnValue(unsignedIntValue);
}

- (long)yy_longValueForKey:(NSString *)key default:(long)def {
    YYReturnValue(longValue);
}
- (unsigned long)yy_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def {
    YYReturnValue(unsignedLongValue);
}

- (long long)yy_longLongValueForKey:(NSString *)key default:(long long)def {
    YYReturnValue(longLongValue);
}
- (unsigned long long)yy_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def {
    YYReturnValue(unsignedLongLongValue);
}

- (float)yy_floatValueForKey:(NSString *)key default:(float)def {
    YYReturnValue(floatValue);
}
- (double)yy_doubleValueForKey:(NSString *)key default:(double)def {
    YYReturnValue(doubleValue);
}

- (NSInteger)yy_integerValueForKey:(NSString *)key default:(NSInteger)def {
    YYReturnValue(integerValue);
}
- (NSUInteger)yy_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def {
    YYReturnValue(unsignedIntegerValue);
}

- (NSNumber *)yy_numverValueForKey:(NSString *)key default:(NSNumber *)def {
    if (key) {
        id value = self[key];
        if (value) {
            if ([value isKindOfClass:[NSNumber class]]) return value;
            if ([value isKindOfClass:[NSString class]]) return [value yy_numberValue];
        }
    }
    return def;
}
- (NSString *)yy_stringValueForKey:(NSString *)key default:(NSString *)def {
    if (key) {
        id value = self[key];
        if (value) {
            if ([value isKindOfClass:[NSNumber class]]) return [value stringValue];
            if ([value isKindOfClass:[NSString class]]) return value;
        }
    }
    return def;
}


@end



#pragma mark - NSMutableDictionary

/**
 Provide some some common method for `NSMutableDictionary`.
 */
@implementation NSMutableDictionary (YYExtension)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (NSMutableDictionary *)yy_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSMutableDictionary class]]) return dictionary;
    return nil;
}

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (NSMutableDictionary *)yy_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yy_dictionaryWithPlistData:data];
}


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (id)yy_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)yy_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dic[key] = value;
        }
    }
    return dic;
}

@end





