//
//  JMSkuDisplayView.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"
#import "YYRightImageButton.h"

@class JMSkuDisplayView;

typedef void(^JMSkuDisplayViewCloseButtonDidClickBlock)(JMSkuDisplayView *button);
typedef void(^JMSkuDisplayViewUsageButtonDidClickBlock)(JMSkuDisplayView *button);

@interface JMSkuDisplayViewModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *skuImageName;
@property (nonatomic, copy) NSString *price; //非预售时

@property (nonatomic, copy) NSString *depositPrice; ///< 定金
@property (nonatomic, strong) NSAttributedString *depositPriceAttributed; ///< 定金小数点部分字体缩小
@property (nonatomic, copy) NSString *salePrice; ///< 当前销售价
@property (nonatomic, strong) NSAttributedString *salePriceAttributed; ///< 当前销售价小数点部分字体缩小

@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *selectingTip;
@property (nonatomic, copy) NSString *usageText;

//94
+ (CGFloat)viewHeight;

@end

/**< Sku图片，价格等展示 */
@interface JMSkuDisplayView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UILabel *depositPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *salePriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *depositPriceIndicatorLabel;
@property (nonatomic, weak) IBOutlet UILabel *salePriceIndicatorLabel;

@property (nonatomic, weak) IBOutlet UILabel *stockLabel;
@property (nonatomic, weak) IBOutlet UILabel *selectingTipLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet YYRightImageButton *useageButton;


@property (nonatomic, strong) JMSkuDisplayViewModel *model;
@property (nonatomic, copy) JMSkuDisplayViewCloseButtonDidClickBlock closeButtonDidClickBlock;
@property (nonatomic, copy) JMSkuDisplayViewUsageButtonDidClickBlock usageButtonDidClickBlock;

+ (instancetype)instanceFromNib;
- (void)reloadWithData:(id<JMComponentModel>)model;

@end
