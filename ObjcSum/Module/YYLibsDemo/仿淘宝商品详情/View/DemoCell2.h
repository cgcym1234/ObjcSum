//
//  DemoCell2.h
//  ObjcSum
//
//  Created by yangyuan on 2016/9/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMRenderableTableView.h"

@interface DemoCell2 : UITableViewCell<JMRenderableCell>

- (void)updateWithCellModel:(id)model indexPath:(NSIndexPath *)indexPath containerView:(UIView *)view;

@end
