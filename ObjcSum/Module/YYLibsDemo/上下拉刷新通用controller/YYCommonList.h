//
//  YYCommonList.h
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//默认key
#define CurrentPageKey @"currentPage"
#define LastPageKey @"lastPage"
#define ItemsKey @"list"

/**
 放入YYCommonList的类必须实现的协议,便利初始化
 */
@protocol YYCommonListItemProtocol <NSObject>

@required
+ (instancetype)instanceWithDictionary:(NSDictionary *)dictionary;

@end

/**
 *  通用cell必须实现的协议,更新UI
 */
@protocol YYCommonCellProtocol <NSObject>

@required
- (void)updateWithItem:(id)item inTableView:(UITableView *)tableView atIndexpath:(NSIndexPath *)indexPath;

@end

#pragma mark - 一个用于存储分页数据的通用数组管理器,可用于规范化的接口

/**
 * 比如接口数据都是类似这种格式 
 {
 "list": [],
 "lastPage": true
 }
 */

@interface YYCommonList : NSObject

//当前是第几页
@property (nonatomic, assign) NSInteger currentPage;
//是否最后一页
@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) Class itemClass;
@property (nonatomic, copy) NSString *lastPageKey;
@property (nonatomic, copy) NSString *itemsKey;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary itemClass:(Class<YYCommonListItemProtocol>)itemClass;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                         itemClass:(Class<YYCommonListItemProtocol>)itemClass
                    currentPageKey:(NSString *)currentPageKey
                       lastPageKey:(NSString *)lastPageKey
                          itemsKey:(NSString *)itemsKey;

/**
 *  注意这个方法只会改变self.lastPage和self.items
 其他属性不变
 */
- (void)appendList:(YYCommonList *)list;

@end
