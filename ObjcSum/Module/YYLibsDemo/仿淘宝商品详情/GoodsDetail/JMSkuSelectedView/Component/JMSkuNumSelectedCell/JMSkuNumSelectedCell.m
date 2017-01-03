//
//  JMSkuNumSelectedCell.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuNumSelectedCell.h"
#import "JMSkuSelectedViewConsts.h"

@implementation JMSkuNumSelectedCellModel


- (NSInteger)viewHeight {
    return 22;
}

- (void)setNum:(NSString *)num {
    if (![num isKindOfClass:[NSString class]]) {
        return;
    }
    _num = [num copy];
    _numInteger = [_num integerValue];
}

@end

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@interface JMSkuNumSelectedCell ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuNumSelectedCell


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    _addButton.exclusiveTouch = YES;
    _minusButton.exclusiveTouch = YES;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuNumSelectedCellModel class]]) {
        return;
    }
    _model = model;
    _textField.text = _model.num;
}

#pragma mark - Private


#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter



@end
