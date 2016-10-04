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

- (void)updateWithCellModel:(id)model indexPath:(NSIndexPath *)indexPath containerView:(UIView *)view {
    DemoCellModel *item = model;
    self.name.text = item.text;
}

@end
