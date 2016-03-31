//
//  ShowRoomCell.h
//  ObjcSum
//
//  Created by sihuan on 16/3/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowRoomCellModel.h"

@interface ShowRoomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *desc;

- (void)updateUI:(ShowRoomCellModel *)item;

@end
