//
//  JMSkuDisplayView.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"

@class JMSkuDisplayView;

typedef void(^JMSkuDisplayViewCloseButtonDidClickBlock)(JMSkuDisplayView *button);

@interface JMSkuDisplayViewModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *skuImageName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *selectingTip;

//94
+ (CGFloat)viewHeight;

@end

/**< Sku图片，价格等展示 */
@interface JMSkuDisplayView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *stockLabel;
@property (nonatomic, weak) IBOutlet UILabel *selectingTipLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) JMSkuDisplayViewModel *model;
@property (nonatomic, copy) JMSkuDisplayViewCloseButtonDidClickBlock closeButtonDidClickBlock;

+ (instancetype)instanceFromNib;
- (void)reloadWithData:(id<JMComponentModel>)model;

@end
