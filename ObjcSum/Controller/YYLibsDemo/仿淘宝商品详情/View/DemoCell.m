//
//  DemoCell.m
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "DemoCell.h"

@implementation DemoCell

- (void)awakeFromNib {
}

- (void)updateWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inView:(UIView *)view {
    DemoCellModel *item = model;
    self.name.text = item.text;
}

@end
