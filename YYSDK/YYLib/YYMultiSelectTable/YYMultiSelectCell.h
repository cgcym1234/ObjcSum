//
//  YYMultiSelectCell.h
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMultiSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)updateUI:(id)item atIndexpath:(NSIndexPath *)indexPath;

@end
