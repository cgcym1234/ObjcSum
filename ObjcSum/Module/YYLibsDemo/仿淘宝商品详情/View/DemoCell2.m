//
//  DemoCell2.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "DemoCell2.h"
#import "DemoCellModel2.h"

@implementation DemoCell2

- (void)updateWithCellModel:(id)model indexPath:(NSIndexPath *)indexPath containerView:(UIView *)view {
    DemoCellModel2 *item = model;
    self.textLabel.text = item.text;
}

@end
