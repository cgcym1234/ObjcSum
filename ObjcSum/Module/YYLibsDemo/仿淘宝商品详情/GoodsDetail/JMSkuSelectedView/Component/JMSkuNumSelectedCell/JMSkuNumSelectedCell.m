//
//  JMSkuNumSelectedCell.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuNumSelectedCell.h"
#import "JMSkuSelectedViewConsts.h"
#import "JMSkuGroupHeader.h"
#import "ReactiveCocoa.h"
#import "UIButton+JMCategory.h"
#import "YYInputAccessoryViewWithCancel.h"

@implementation JMSkuNumSelectedCellModel

- (instancetype)init {
    if (self= [super init]) {
        _num = 1;
        _minusButtonState = UIControlStateDisabled;
        _addButtonState = UIControlStateNormal;
    }
    return self;
}

- (NSInteger)viewHeight {
    return 22;
}

- (JMSkuGroupModel *)header {
    if (!_header) {
        _header = [JMSkuGroupModel new];
        _header.groupName = @"购买数量";
        _header.type = @" ";
    }
    return _header;
}

@end

#pragma mark - Const



@interface JMSkuNumSelectedCell ()

@property (nonatomic, strong) YYInputAccessoryViewWithCancel *accessoryView;

@end

@implementation JMSkuNumSelectedCell


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    _addButton.exclusiveTouch = YES;
    _minusButton.exclusiveTouch = YES;
    
    _addButton.tag = JMSkuNumSelectedButtonActionAdd;
    _minusButton.tag = JMSkuNumSelectedButtonActionMinus;
    
    [_addButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_minusButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField.inputAccessoryView = self.accessoryView;
    
    __weak __typeof(self) weakSelf = self;
    [[_textField rac_textSignal] subscribeNext:^(id value) {
        if ([value integerValue] == 0) {
            weakSelf.textField.text = @"0";
            return;
        }
        
        [weakSelf notifyValueChanged];
    }];
}

#pragma mark - Override


#pragma mark - Public

- (void)reloadData {
    [self reloadWithData:_model];
}

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuNumSelectedCellModel class]]) {
        return;
    }
    _model = model;
    _textField.text = [@(_model.num) stringValue];
    
    [_minusButton setState:_model.minusButtonState];
    [_addButton setState:_model.addButtonState];
}

#pragma mark - Private

- (void)notifyValueChanged {
    if ([self.delegate respondsToSelector:@selector(jmSkuNumSelectedCell:inputValueChanged:)]) {
        [self.delegate jmSkuNumSelectedCell:self inputValueChanged:self.textField.text];
    }
}

- (void)buttonDidClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(jmSkuNumSelectedCell:didClickWithAction:)]) {
        [_delegate jmSkuNumSelectedCell:self didClickWithAction:button.tag];
    }
}

#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

- (YYInputAccessoryViewWithCancel *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [YYInputAccessoryViewWithCancel instanceFromNib];
        _accessoryView.cancelButton.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _accessoryView.didClickedBlock = ^(YYInputAccessoryViewWithCancel *view, YYInputAccessoryViewWithCancelType type) {
            [weakSelf.textField resignFirstResponder];
            [weakSelf notifyValueChanged];
        };
    }
    return _accessoryView;
}

@end
