//
//  YYActionSheetCell.m
//  ObjcSum
//
//  Created by yangyuan on 2017/6/7.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "YYActionSheetCell.h"



@implementation YYActionSheetItem

+ (instancetype)instanceWithTitle:(NSString *)title {
    YYActionSheetItem *item = [YYActionSheetItem new];
    item.title = title;
    item.titleColor = kBLACKTEXTCOLOR;
    return item;
}

@end

@interface YYActionSheetCell ()

@end

@implementation YYActionSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setModel:(YYActionSheetItem *)model {
    _model = model;
    _titleLabel.text = model.title;
    _titleLabel.textColor = model.titleColor;
}

@end
