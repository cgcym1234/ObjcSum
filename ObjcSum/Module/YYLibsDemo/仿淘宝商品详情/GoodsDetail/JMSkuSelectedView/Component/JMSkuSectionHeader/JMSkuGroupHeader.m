//
//  JMSkuGroupHeader.m
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMSkuGroupHeader.h"
#import "UIView+JMCategory.h"
#import "JMSkuSelectedViewConsts.h"

#pragma mark - Const

static NSInteger const HeightForCommonCell = 49;

static NSString * const KeyCell = @"KeyCell";

@implementation JMSkuGroupModel


@end

@interface JMSkuGroupHeader ()

@property (nonatomic, strong) UIView *inputTextView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JMSkuGroupHeader


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [self addBorderTopPadding:JMSkuSelectedViewPaddingLeftRight height:kSplitLineHeightFix(1) color:JMSkuSelectedViewSepratorColor];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuGroupModel class]]) {
        return;
    }
    _model = model;
    _skuGroupNameLabel.text = _model.groupName;
}

#pragma mark - Private


#pragma mark - Delegate


#pragma mark - Setter

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
}

#pragma mark - Getter

+ (CGFloat)viewHeight {
    return 36;
}


@end
