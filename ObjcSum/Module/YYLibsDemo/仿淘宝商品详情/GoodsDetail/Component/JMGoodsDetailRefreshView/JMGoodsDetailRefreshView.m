//
//  JMGoodsDetailRefreshView.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailRefreshView.h"

@interface JMGoodsDetailRefreshView ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation JMGoodsDetailRefreshView

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)showWithState:(YYRefreshState)state config:(YYRefreshConfig *)config animated:(BOOL)animated {
    _textLabel.text = config.textIdle;
}

@end
