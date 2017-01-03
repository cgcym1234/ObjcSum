//
//  JMSkuAdditionalInfoCell.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuAdditionalInfoCell.h"
#import "JMSkuSelectedViewConsts.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";


@implementation JMSkuAdditionalInfoCellModel

- (NSInteger)viewHeight {
    return 42;
}

@end

@interface JMSkuAdditionalInfoCell ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuAdditionalInfoCell


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuAdditionalInfoCellModel class]]) {
        return;
    }
    _model = model;
    _leftLabel.text = _model.mainText;
    _rightLabel.text = _model.additionalText;
}

#pragma mark - Private


#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter



@end
