//
//  FastRecordBaseCell.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecordCellModel.h"

@interface FastRecordBaseCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) FastRecordCellModel *fastRecordCellModel;
@property (nonatomic, weak) id<FastRecordCellActionDelegate> delegate;
@property (nonatomic, copy) NSIndexPath *indexPath;

- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath;

@end
