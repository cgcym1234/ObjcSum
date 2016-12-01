//
//  JMGoodsDetailShareButton.h
//  JuMei
//
//  Created by yuany on 9/18/16.
//  Copyright © 2016 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsDetailContainerViewController, JMGoodsDetailShareButton;

typedef void(^JMGoodsDetailShareButtonDidClickBlock)(JMGoodsDetailShareButton *shareButton);

/**< 详情页分享按钮 */
@interface JMGoodsDetailShareButton : UIButton

@property (nonatomic, copy) JMGoodsDetailShareButtonDidClickBlock didClickBlock;





@end
