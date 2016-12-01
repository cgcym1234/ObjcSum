//
//  JMGoodsDetailGoodsContainerViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsDetailContainerViewController, JMGoodsDetailGoodsViewController, JMGoodsDetailGraphicViewController, JMGoodsDetailManager;

/** 重构版商品详情 商品页容器VC 主要管理商品列表和详情上下切换相关动画*/
@interface JMGoodsDetailGoodsContainerViewController : UIViewController

//@property (nonatomic, strong) MAProduct *product;

@property (nonatomic, weak) JMGoodsDetailManager *goodsDetailManager;

@property (nonatomic, strong) JMGoodsDetailGoodsViewController *goodsViewController;
/*
 因为这个详情和 JMGoodsDetailContainerViewController下面的详情是一样的
 所以优化为这里使用外部传入的JMGoodsDetailGraphicViewController
 */
@property (nonatomic, weak) JMGoodsDetailGraphicViewController *graphicViewController;

/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;


@end
