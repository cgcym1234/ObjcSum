//
//  ShowRoomListModel.h
//  MLLCustomer
//
//  Created by sihuan on 15/5/4.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowRoomListModel : NSObject

@property (nonatomic, strong) NSMutableArray *cellModelArr;
@property (nonatomic, strong) NSMutableArray *sectionModelArr;

@property (nonatomic, copy) NSNumber *currentPage;
@property (nonatomic, copy) NSNumber *totalPage;
@property (nonatomic, copy) NSNumber *size;

@property (nonatomic, assign) NSInteger selectedIdx;//cellModelArr的索引

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, assign) BOOL needScroll;


+ (instancetype)sharedInstance;

- (void)update:(ShowRoomListModel *)model;
- (void)append:(ShowRoomListModel *)model;

- (instancetype)initWithValues: (NSDictionary*)dict;

@end
