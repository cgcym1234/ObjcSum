//
//  JMSkuConfirmView.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuConfirmView.h"
#import "UIButton+setBackgroundColorForState.h"
#import "UIButton+JMCategory.h"
#import "UIView+JMCategory.h"
#import "JMSkuSelectedViewConsts.h"

@implementation JMSkuConfirmViewModel

+ (CGFloat)viewHeight {
    return 49;
}
@end

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@interface JMSkuConfirmView ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuConfirmView


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
    
    [self addBorderTopPadding:0 height:kSplitLineHeightFix(1) color:JMSkuSelectedViewSepratorColor];
    
    [_button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    _button.exclusiveTouch = YES;
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
    if (![model isKindOfClass:[JMSkuConfirmViewModel class]]) {
        return;
    }
    _model = model;
    [_button setTitleNormal:_model.text];
    [_button setState:_model.state];
    
}

#pragma mark - Private

- (void)buttonDidClick:(UIButton *)button {
    button.enabled = NO;
    if (_didClickBlock) {
        _didClickBlock(self);
    }
}

#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter



@end

