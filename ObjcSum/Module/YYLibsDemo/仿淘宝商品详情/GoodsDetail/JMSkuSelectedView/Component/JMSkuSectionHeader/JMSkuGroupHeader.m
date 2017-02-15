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
#import "YYRightImageButton.h"
#import "NSString+JMCategory.h"

#pragma mark - Const


@implementation JMSkuGroupModel


@end

@interface JMSkuGroupHeader ()



@end

@implementation JMSkuGroupHeader


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContext];
}

- (void)setupContext {
    
    [self addBorderTopPadding:JMSkuSelectedViewPaddingLeftRight height:kSplitLineHeightFix(1) color:JMSkuSelectedViewSepratorColor];
    
    _skuGroupNameLabel.text = nil;
    [self setupUseageButton];
}

- (void)setupUseageButton {
    _useageButton.textLabelFont = [UIFont systemFontOfSize:12];
    _useageButton.textLabelColor = ColorFromRGBHex(0xFE4070);
    _useageButton.backgroundColor = [UIColor whiteColor];
    _useageButton.spacing = 2;
    _useageButton.image = [UIImage imageNamed:@"sku_usage"];
    _useageButton.imageSize = CGSizeMake(11, 11);
    
    __weak __typeof(self) weakSelf = self;
    _useageButton.didClickBlock = ^(YYRightImageButton *button) {
        if (weakSelf.usageButtonDidClickBlock) {
            weakSelf.usageButtonDidClickBlock(weakSelf);
        }
    };
}

#pragma mark - Override

- (void)prepareForReuse {
    _skuGroupNameLabel.text = nil;
}

#pragma mark - Public

- (void)reloadWithData:(id<JMComponentModel>)model {
    if (![model isKindOfClass:[JMSkuGroupModel class]]) {
        return;
    }
    _model = model;
    _skuGroupNameLabel.text = _model.groupName;
    
    _useageButton.text = _model.usageText;
    _useageButton.hidden = !_useageButton.text.isNotBlank;
}

#pragma mark - Private


#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

+ (CGFloat)viewHeight {
    return 36;
}


@end
