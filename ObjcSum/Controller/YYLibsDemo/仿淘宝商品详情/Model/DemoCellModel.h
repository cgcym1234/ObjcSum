//
//  DemoCellModel.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetail.h"


@interface DemoCellModel : NSObject<GoodsDetailModel>

@property (nonatomic, strong, readonly) NSString *cellIdentifier;

@property (nonatomic, strong) NSString *text;

@end
