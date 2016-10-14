//
//  YYMultiSelectCell.m
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "YYMultiSelectCell.h"
#import "YYMultiSelectModel.h"

@implementation YYMultiSelectCell

- (void)awakeFromNib {
    // Initialization code
    _selectionButton.userInteractionEnabled = NO;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)updateUI:(id)item atIndexpath:(NSIndexPath *)indexPath {
    YYMultiSelectModel *model = item;
    _name.text = model.name;
    UIImage *image = model.checked ? [UIImage imageNamed:@"ic_radiobutton_checked"] : [UIImage imageNamed:@"ic_radiobutton"];
    [_selectionButton setImage:image forState:UIControlStateNormal];
}
@end
