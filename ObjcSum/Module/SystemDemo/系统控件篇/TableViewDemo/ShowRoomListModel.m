//
//  ShowRoomListModel.m
//  MLLCustomer
//
//  Created by sihuan on 15/5/4.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "ShowRoomListModel.h"
#import "ShowRoomCellModel.h"



static ShowRoomListModel *instance;

@implementation ShowRoomListModel


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        instance = [[ShowRoomListModel alloc] init];
    });
    
    return instance;
}

- (void)update:(ShowRoomListModel *)model {
    instance.cellModelArr = [NSMutableArray arrayWithArray:[self sortedByUserLove:model.cellModelArr]];
    instance.sectionModelArr = [NSMutableArray arrayWithArray:model.sectionModelArr];
    instance.totalPage = model.totalPage;
    instance.size = model.size;
    instance.currentPage = model.currentPage;
}
- (void)append:(ShowRoomListModel *)model {
    [instance.cellModelArr addObjectsFromArray:model.cellModelArr];
    instance.cellModelArr = [NSMutableArray arrayWithArray:[self sortedByUserLove:instance.cellModelArr]];
    
    [instance.sectionModelArr addObjectsFromArray:model.sectionModelArr];
    instance.totalPage = model.totalPage;
    instance.size = model.size;
    instance.currentPage = model.currentPage;
}

- (instancetype)initWithValues:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSDictionary *ybjpages = dict[@"ybjpages"];
        if (ybjpages) {
            self.currentPage = ybjpages[@"current_page"];
            self.totalPage = ybjpages[@"total_page"];
            self.size = ybjpages[@"size"];
        }
        
        NSArray *ybjlist = dict[@"ybjlist"];
        if ([ybjlist isKindOfClass:[NSArray class]] && ybjlist.count > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:ybjlist.count];
            NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:ybjlist.count];
            
            for (NSDictionary *ybjDic in ybjlist) {
                
                NSArray *suitArr = ybjDic[@"suit"];
                NSMutableArray *rowArr = [NSMutableArray arrayWithCapacity:suitArr.count];
                
                for (NSDictionary *suitDic in suitArr) {
                    ShowRoomCellModel *item = [[ShowRoomCellModel alloc] initWithValues:ybjDic];
                    [item setSuitValues:suitDic];
                    
                    [arr addObject:item];
                    [rowArr addObject:item];
                }
                
                [sectionArr addObject:rowArr];
            }
            
            self.cellModelArr = arr;
            self.sectionModelArr = sectionArr;
        }
        
    }
    return self;
}

- (NSArray *)sortedByUserLove:(NSArray *)arr {
    NSComparator cmptr = ^(ShowRoomCellModel * obj1, ShowRoomCellModel * obj2){
        if (obj1.userLove > obj2.userLove) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (obj1.userLove < obj2.userLove) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSInteger i = 0;
    NSArray *sortedArr = [arr sortedArrayUsingComparator:cmptr];
    for (ShowRoomCellModel *item in sortedArr) {
        item.indexOfCellModelArr = i++;
    }
    return sortedArr;
}

@end
