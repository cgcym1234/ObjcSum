//
//  GoodsDetailContainer.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GoodsDetailType) {
    GoodsDetailTypeNomal,//普通商品
    GoodsDetailTypeAuction//拍卖商品
};

@interface GoodsDetailContainer : UIViewController

+ (void)pushNewInstanceFromViewController:(__weak UIViewController *)fromVc goodsType:(GoodsDetailType)type;

@end
