//
//  JMSimpleSegmentItem.m
//  JuMei
//
//  Created by yangyuan on 2016/9/27.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSimpleSegmentItem.h"

@implementation JMSimpleSegmentItemModel

+ (instancetype)instanceWithText:(NSString *)text detailText:(NSString *)detailText {
    JMSimpleSegmentItemModel *model = [JMSimpleSegmentItemModel new];
    model.text = text;
    model.detailText = detailText;
    return model;
}

@end

@interface JMSimpleSegmentItem()

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailTextLabel;

@end

@implementation JMSimpleSegmentItem

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)reloadWithModel:(JMSimpleSegmentItemModel *)model {
    _model = model;
    _textLabel.text = model.text;
    _detailTextLabel.text = model.detailText;
}

- (void)setSelected:(BOOL)selected {
    UIColor *color = selected ? _selectedColor : _nomalColor;
    _textLabel.textColor = color;
    _detailTextLabel.textColor = color;
}


@end
