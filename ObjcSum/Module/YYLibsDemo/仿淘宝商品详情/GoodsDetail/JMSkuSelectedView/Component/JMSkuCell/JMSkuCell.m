//
//  JMSkuCell.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuCell.h"
#import "UIButton+setBackgroundColorForState.h"
#import "UIButton+JMCategory.h"
#import "JMSkuSelectedViewConsts.h"
#import "JMSkuGroupHeader.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@implementation JMSkuCellModel

- (CGFloat)viewHeight {
    return 25;
}

- (NSMutableArray<SkuInfo *> *)skuInfosFiltered {
    if (!_skuInfosFiltered) {
        _skuInfosFiltered = [NSMutableArray new];
    }
    return _skuInfosFiltered;
}

@end

@interface JMSkuCell ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuCell


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    [_skuButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    _skuButton.exclusiveTouch = YES;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuCellModel class]]) {
        return;
    }
    _model = model;
    [_skuButton setTitleNormal:_model.text];
    [_skuButton setState:_model.state];
}

#pragma mark - Private

- (void)buttonDidClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(jmSkuCellDidClicked:)]) {
        [_delegate jmSkuCellDidClicked:self];
    }
}

#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter



@end
