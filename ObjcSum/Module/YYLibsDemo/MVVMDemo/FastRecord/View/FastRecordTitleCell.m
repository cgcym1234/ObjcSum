//
//  FastRecordTitleCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordTitleCell.h"

#define ColorSelected  [UIColor colorWithRed:49/255.0 green:189/255.0 blue:196/255.0 alpha:1]
#define ColorDeSelected  [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1]

@interface FastRecordTitleCell ()

@end

@implementation FastRecordTitleCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _leftButton.tag = FastRecordTypeCustomer;
    _rightButton.tag = FastRecordTypePersonal;
    
    _leftButton.layer.borderWidth = 1;
    _rightButton.layer.borderWidth = 1;
    
    _leftButton.layer.cornerRadius = 2;
    _rightButton.layer.cornerRadius = 2;
    _leftButton.layer.masksToBounds = YES;
    _rightButton.layer.masksToBounds = YES;
    
    
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setSelectedType:(FastRecordType)selectedType {
    _selectedType = selectedType;
    self.fastRecordCellModel.type = selectedType;
    BOOL leftButtonEnabled;
    switch (selectedType) {
        case FastRecordTypeCustomer:
            leftButtonEnabled = NO;
            _rightButton.enabled = YES;
            break;
        case FastRecordTypePersonal:
            leftButtonEnabled = YES;
            _rightButton.enabled = NO;
            break;
    }
    _leftButton.enabled = leftButtonEnabled;
    _rightButton.enabled = !leftButtonEnabled;
    
    _leftButton.layer.borderColor = leftButtonEnabled ? ColorDeSelected.CGColor : ColorSelected.CGColor;
    _rightButton.layer.borderColor = !leftButtonEnabled ? ColorDeSelected.CGColor : ColorSelected.CGColor;
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    self.selectedType = item.type;
}

#pragma mark - Action
- (IBAction)fastRecordCellDidCliced:(UIButton *)sender {
    self.selectedType = sender.tag;
    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
        [self.delegate  fastRecordCell:self didClicked:FastRecordActionTypeTitle atIndexpath:self.indexPath withObject:@(sender.tag)];
    }
}

@end
