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
#import "UIImageView+JMNetworking.h"
#import "NSString+YYSDK.h"

#pragma mark - Const



@implementation JMSkuDisplayViewModel

+ (CGFloat)viewHeight {
    return 94;
}
@end



@interface JMSkuDisplayView ()



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
    
    _imageView.backgroundColor = [UIColor whiteColor];
    [_imageView addShadowOffset:CGSizeMake(0.5, 2) radius:2.5 opacity:1 color:[UIColor lightGrayColor]];
    
    [_closeButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ;
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
    
    BOOL refreshImage = ![_model.skuImageName isEqualToString:[(JMSkuDisplayViewModel *)model skuImageName]];
    
    _model = model;
    
    if (_model.depositPrice.isNotBlank) {
        _depositPriceLabel.text = _model.depositPrice;
        _salePriceLabel.text = _model.salePrice;
        [self setDepositPriceLabelHidden:NO];
        _priceLabel.hidden = YES;
    } else {
        _priceLabel.text = _model.price;
        [self setDepositPriceLabelHidden:YES];
         _priceLabel.hidden = NO;
    }
    
    _stockLabel.text = _model.stock;
    _selectingTipLabel.text = _model.selectingTip;
    
    if (refreshImage) {
//        [_imageView setImageWithURL:_model.skuImageName animation:nil];
    }
    _useageButton.text = _model.usageText;
    _useageButton.hidden = !_useageButton.text.isNotBlank;
}

- (void)setDepositPriceLabelHidden:(BOOL)hidden {
    _depositPriceLabel.hidden = hidden;
    _salePriceLabel.hidden = hidden;
    _depositPriceIndicatorLabel.hidden = hidden;
    _salePriceIndicatorLabel.hidden = hidden;
}

#pragma mark - Private

- (void)closeButtonDidClick:(UIButton *)button {
    if (_closeButtonDidClickBlock) {
        _closeButtonDidClickBlock(self);
    }
}

#pragma mark - Delegate


#pragma mark - Setter



#pragma mark - Getter



@end
