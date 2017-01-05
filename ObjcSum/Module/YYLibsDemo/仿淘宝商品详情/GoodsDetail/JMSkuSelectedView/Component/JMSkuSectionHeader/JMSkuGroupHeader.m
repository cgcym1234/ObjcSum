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
}

#pragma mark - Private


#pragma mark - Delegate


#pragma mark - Setter


#pragma mark - Getter

+ (CGFloat)viewHeight {
    return 36;
}


@end
