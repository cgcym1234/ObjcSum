//
//  JMSkuConfirmView.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"

@class JMSkuConfirmView;

typedef void(^JMSkuConfirmViewButtonDidClickBlock)(JMSkuConfirmView *button);

@interface JMSkuConfirmViewModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIControlState state;

//49
+ (CGFloat)viewHeight;

@end


/**< 确认按钮 */
@interface JMSkuConfirmView : UIView<JMComponent>

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, copy) JMSkuConfirmViewButtonDidClickBlock didClickBlock;
@property (nonatomic, strong) JMSkuConfirmViewModel *model;

+ (instancetype)instanceFromNib;
- (void)reloadWithData:(id<JMComponentModel>)model;

@end
