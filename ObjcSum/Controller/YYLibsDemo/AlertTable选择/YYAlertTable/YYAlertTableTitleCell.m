//
//  YYAlertTableTitleCell.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertTableTitleCell.h"

@implementation YYAlertTableTitleCell

- (void)awakeFromNib {
    self.textLabel.textColor = [UIColor colorWithRed:39/255.0 green:167/255.0 blue:224/255.0 alpha:1];
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
