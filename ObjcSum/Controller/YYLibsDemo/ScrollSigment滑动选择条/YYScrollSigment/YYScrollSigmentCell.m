//
//  YYScrollSigmentCell.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYScrollSigmentCell.h"
#import "YYScrollSigment.h"

@implementation YYScrollSigmentCell

- (void)awakeFromNib {
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithWhite:0.62 alpha:0.62];
    self.selectedBackgroundView = bg;
    [self bringSubviewToFront:self.selectedBackgroundView];
    _titleLabel.textColor = ItemColorNormal;
}

- (void)updateWithItem:(id)item atIndexPath:(NSIndexPath *)indexPath inView:(YYScrollSigment *)view {
    _title = (NSString *)item;
    _titleLabel.text = _title;
}

- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated {
    _titleLabel.textColor = isSelected ? ItemColorSelected : ItemColorNormal;
}


@end
