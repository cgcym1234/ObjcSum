//
//  DemoCellModel.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetail.h"
#import "JMRenderableTableView.h"


@interface DemoCellModel : NSObject<JMRenderableCellModel>

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) NSString *text;

@end
