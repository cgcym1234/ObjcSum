//
//  DemoCell.m
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "DemoCell.h"
#import "DemoCellModel.h"

@implementation DemoCell

- (void)updateWithModel:(id<JMRenderableCellModel>)model indexPath:(NSIndexPath *)indexPath container:(UIView *)container {
    DemoCellModel *item = model;
    self.name.text = item.text;
}

@end
