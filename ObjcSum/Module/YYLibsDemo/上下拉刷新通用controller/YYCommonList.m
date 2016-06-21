//
//  YYCommonList.m
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYCommonList.h"

@implementation YYCommonList

- (instancetype)initWithDictionary:(NSDictionary *)dictionary itemClass:(Class<YYCommonListItemProtocol>)itemClass {
    return [self initWithDictionary:dictionary itemClass:itemClass currentPageKey:CurrentPageKey lastPageKey:LastPageKey itemsKey:ItemsKey];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                         itemClass:(Class<YYCommonListItemProtocol>)itemClass
                    currentPageKey:(NSString *)currentPageKey
                       lastPageKey:(NSString *)lastPageKey
                          itemsKey:(NSString *)itemsKey {
    if (!itemClass) {
        return nil;
    }
    
    if (self = [super init]) {
        if (currentPageKey) {
            self.currentPage = [dictionary[currentPageKey] boolValue];
        }
        
        if (lastPageKey) {
            self.lastPage = [dictionary[lastPageKey] boolValue];
        }
        
        if (itemsKey) {
            NSArray *items = dictionary[itemsKey];
            if (items) {
                NSMutableArray * listItems = [NSMutableArray array];
                for(NSDictionary * listDictionary in items) {
                    id listItem = [itemClass instanceWithDictionary:listDictionary];
                    [listItems addObject:listItem];
                }
                self.items = listItems;
            }
        }
    }
    
    return self;
}

- (void)appendList:(YYCommonList *)list {
    _lastPage = list.lastPage;
    if (_items) {
        if (list.items) {
            [_items addObjectsFromArray:list.items];
        }
    } else {
        _items = [list.items mutableCopy];
    }
}


@end
