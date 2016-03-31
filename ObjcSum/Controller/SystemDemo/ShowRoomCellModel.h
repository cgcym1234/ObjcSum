//
//  ShowRoomCellModel.h
//  MLLCustomer
//
//  Created by sihuan on 15/4/30.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowRoomCellModel : NSObject

@property (nonatomic, copy) NSString *exprId;           //样板间id
@property (nonatomic, copy) NSString *suitId;           //套系id
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *designeDesc;
@property (nonatomic, copy) NSString *districtName;     //区域名称
@property (nonatomic, copy) NSString *houseName;        //楼盘名称
@property (nonatomic, copy) NSString *normalImgUrl;
@property (nonatomic, copy) NSString *normalImgUrl_1;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *imgUrl_6;
@property (nonatomic, copy) NSString *imgUrl_6p;
@property (nonatomic, copy) NSString *userLoveNum;
@property (nonatomic, copy) NSString *ybjPosition;      //纬度，经度
@property (nonatomic, copy) NSString *ybjStyle;

@property (nonatomic, assign) NSInteger userLove;

@property (nonatomic, assign) NSInteger indexOfCellModelArr; //根据喜欢数排序后在ShowRoomListModel.cellModelArr的索引，地图中需要使用


- (instancetype)initWithValues:(NSDictionary*)dict;

- (void)setSuitValues:(NSDictionary *)dict;

@end
