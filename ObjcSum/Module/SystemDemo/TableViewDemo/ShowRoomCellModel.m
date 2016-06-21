//
//  ShowRoomCellModel.m
//  MLLCustomer
//
//  Created by sihuan on 15/4/30.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "ShowRoomCellModel.h"
#import "NSString+YYExtension.h"
#import <UIKit/UIKit.h>

#define IS_IPAD                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA               ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH            ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT           ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5             (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6             (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P            (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation ShowRoomCellModel

/**
 
 "expr_name": "成都金牛区体验馆",
 "province_id": "24",
 "city_id": "272",
 "district_id": "15149",
 "house_id": "35837",
 "expr_id": "329",
 "province": "四川",
 "city": "成都",
 "district": "金牛区",
 "house_name": "华润银杏华庭",
 "suit_id": "19,12,13,15,16,17,18,20",
 "position": "120,456",
 */
- (instancetype)initWithValues:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.cityName = dict[@"city"];
        
        self.districtName = dict[@"district"];
        self.exprId = dict[@"expr_id"];
        
        self.houseName = dict[@"house_name"];
        self.ybjPosition = dict[@"position"];
        
    }
    return self;
}

- (instancetype)initWithDetailValues:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.cityName = dict[@"ybj_city"];
        
        self.districtName = dict[@"ybj_district"];
        self.exprId = dict[@"ybj_expr_id"];
        
        self.houseName = dict[@"ybj_house_name"];
        self.ybjPosition = dict[@"position"];
        
    }
    return self;
}

- (void)setSuitValues:(NSDictionary *)dict {
    self.suitId = dict[@"id"];
    self.designeDesc = [dict[@"design_text"] yy_stringByTrim];
    
    self.imgUrl_6 = dict[@"img_710_473"];
    self.imgUrl_6p = dict[@"img_1182_788"];
    _imgUrl = IS_IPHONE_6P ? _imgUrl_6p : _imgUrl_6;
    self.userLoveNum = dict[@"user_love_num"];
    if (!_userLoveNum || _userLoveNum.length == 0) {
        _userLoveNum = @"0";
    }
    
    _userLove = [self.userLoveNum integerValue];
    self.ybjStyle = dict[@"style"];
}



@end
