//
//  JMGoodsDetailLickButton.h
//  JuMei
//
//  Created by yangyuan on 2016/9/18.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsDetailLickButton;

typedef void(^JMGoodsDetailLickButtonDidClickBlock)(JMGoodsDetailLickButton *lickButton);

/**< 详情页喜欢按钮 */
@interface JMGoodsDetailLickButton : UIButton

@property (nonatomic, copy) JMGoodsDetailLickButtonDidClickBlock didClickBlock;

@property (nonatomic, assign, readonly) BOOL collected;



@end
