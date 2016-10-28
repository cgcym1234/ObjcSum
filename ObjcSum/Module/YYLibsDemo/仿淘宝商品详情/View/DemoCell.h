//
//  DemoCell.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMRenderableTableView.h"


@protocol DemoCellDelegate <NSObject>

- (void)demoCellClicked;

@end

@interface DemoCell : UITableViewCell<JMRenderableCell>

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) id<DemoCellDelegate> delegate;

- (void)updateWithModel:(id<JMRenderableCellModel>)model indexPath:(NSIndexPath *)indexPath container:(UIView *)container;

@end
