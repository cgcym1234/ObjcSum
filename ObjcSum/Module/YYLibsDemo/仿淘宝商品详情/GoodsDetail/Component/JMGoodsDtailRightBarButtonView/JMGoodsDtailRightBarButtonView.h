//
//  JMGoodsDtailRightBarButtonView.h
//  JuMei
//
//  Created by yangyuan on 2016/11/10.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMGoodsDetailLickButton.h"
#import "JMGoodsDetailShareButton.h"

/**< 详情页喜欢和分享容器 */
@interface JMGoodsDtailRightBarButtonView : UIView

@property (nonatomic, strong) JMGoodsDetailLickButton *likeButton;
@property (nonatomic, strong) JMGoodsDetailShareButton *shareButton;


@end
