//
//  YYSegmentedControlCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 16/3/16.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "YYSegmentedControlCell.h"



@implementation YYSegmentedControlCell

- (void)awakeFromNib {
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithWhite:0.420 alpha:0.420];
    self.selectedBackgroundView = bg;
    [self bringSubviewToFront:self.selectedBackgroundView];
}

- (void)renderWithItem:(id)item atIndex:(NSInteger)index inSegmentControl:(YYSegmentedControl *)segmenteControl {
    _textLabel.text = item;
}

- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated {
     _textLabel.textColor = isSelected ? ItemColorSelected : ItemColorNormal;
}

@end
