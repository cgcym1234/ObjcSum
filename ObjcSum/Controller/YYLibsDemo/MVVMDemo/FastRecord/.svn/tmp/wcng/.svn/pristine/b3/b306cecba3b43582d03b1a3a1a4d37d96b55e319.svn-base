//
//  FastRecordCell.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecordCellModel.h"

@class FastRecordCell;

@protocol FastRecordCellDelegate <NSObject>

- (void)fastRecordCell:(FastRecordCell *)fastRecordCell didClickedDeleteIconAtIndexpath:(NSIndexPath *)indexPath;
- (void)fastRecordCell:(FastRecordCell *)fastRecordCell didClickedRecordImageAtIndexpath:(NSIndexPath *)indexPath;

@end

@interface FastRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *recordDate;
@property (weak, nonatomic) IBOutlet UIButton *clockIcon;
@property (weak, nonatomic) IBOutlet UIButton *deleteIcon;
@property (weak, nonatomic) IBOutlet UILabel *recordText;
@property (weak, nonatomic) IBOutlet UIView *recordVoiceContainer;
@property (weak, nonatomic) IBOutlet UIImageView *recordImage;

@property (nonatomic, weak) id<FastRecordCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath;

@end
