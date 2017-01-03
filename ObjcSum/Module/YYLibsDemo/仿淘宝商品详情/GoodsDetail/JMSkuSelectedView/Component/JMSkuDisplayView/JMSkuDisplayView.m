//
//  JMSkuDisplayView.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuDisplayView.h"
#import "JMSkuSelectedViewConsts.h"
#import "UIView+JMCategory.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@implementation JMSkuDisplayViewModel

+ (CGFloat)viewHeight {
    return 94;
}
@end



@interface JMSkuDisplayView ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuDisplayView


#pragma mark - Initialization

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [self addBorderBottomPadding:0 height:kSplitLineHeightFix(1) color:JMSkuSelectedViewSepratorColor];
    
    [_closeButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuDisplayViewModel class]]) {
        return;
    }
    _model = model;
    _priceLabel.text = _model.price;
    _stockLabel.text = _model.stock;
    _selectingTipLabel.text = _model.selectingTip;
}

#pragma mark - Private

- (void)closeButtonDidClick:(UIButton *)button {
    if (_closeButtonDidClickBlock) {
        _closeButtonDidClickBlock(self);
    }
}

#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter



@end
