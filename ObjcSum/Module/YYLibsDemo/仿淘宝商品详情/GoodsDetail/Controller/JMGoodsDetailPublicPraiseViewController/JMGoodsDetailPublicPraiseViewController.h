//
//  JMGoodsDetailPublicPraiseViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"

/** 重构版商品详情 口碑VC*/
@interface JMGoodsDetailPublicPraiseViewController : UIViewController

//@property (nonatomic, strong) MAProduct *product;


/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;

- (void)reloadData;

@end
