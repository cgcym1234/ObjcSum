//
//  FastRecordCustomerCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordCustomerCell.h"

@implementation FastRecordCustomerCell

- (void)awakeFromNib {
    // Initialization code
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setText:(NSString *)text {
    _text = text;
    _customerName.text = text;
    _indicator.hidden = text != nil;
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    self.text = item.customerName.length == 0 ? item.customerId : item.customerName;
}


#pragma mark - Action
- (IBAction)fastRecordCellDidCliced:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
        [self.delegate fastRecordCell:self didClicked:FastRecordActionTypeCusomer atIndexpath:self.indexPath withObject:nil];
    }
}

@end
