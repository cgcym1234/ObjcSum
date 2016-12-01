//
//  JMGoodsDetailGraphicViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"

@class JMGoodsDetailGraphicViewController;

@protocol JMGoodsDetailGraphicViewControllerDelegate <NSObject>

- (void)jmGoodsDetailGraphicViewControllerDidClickBackToTopButton:(JMGoodsDetailGraphicViewController *)graphicViewController;

@end

/** 重构版商品详情 图文详情VC*/
@interface JMGoodsDetailGraphicViewController : UIViewController


@property (nonatomic, weak) id<JMGoodsDetailGraphicViewControllerDelegate> delegate;



/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;

- (UIScrollView *)innerScrollView;

- (void)setBackToTopButtonHidden:(BOOL)hidden;

- (void)reloadData;

@end
