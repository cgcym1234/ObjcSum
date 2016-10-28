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

- (void)updateWithModel:(id<JMRenderableCellModel>)model indexPath:(NSIndexPath *)indexPath container:(UIView *)container;

@end
