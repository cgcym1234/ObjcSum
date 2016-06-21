//
//  DemoCell.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoCellModel.h"


@protocol DemoCellDelegate <NSObject>

- (void)demoCellClicked;

@end

@interface DemoCell : UITableViewCell<GoodsDetailCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) id<DemoCellDelegate> delegate;

- (void)updateWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inView:(UIView *)view;

@end
