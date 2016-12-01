//
//  JMGoodsDetailHeaderView.h
//  JuMei
//
//  Created by yangyuan on 2016/11/2.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMBaseViewController, JMGoodsDetailHeaderView;

@protocol JMGoodsDetailHeaderViewDelegate <NSObject>

- (void)jmGoodsDetailHeaderViewHeightDidChanged:(JMGoodsDetailHeaderView *)headerView;
- (void)jmGoodsDetailHeaderViewDidScrolledOverLastImage:(JMGoodsDetailHeaderView *)headerView;

@end


/** 详情页头部图册 */
@interface JMGoodsDetailHeaderView : UIView

@property (nonatomic, weak) id<JMGoodsDetailHeaderViewDelegate> delegate;
@property (nonatomic, weak) JMBaseViewController *containerViewController;

//默认的图片，用于加入购物车等动画
@property (nonatomic, weak, readonly) UIImage                                *defaultGoodsImage;
//当前选中的image，用于分享等
@property (nonatomic, weak, readonly) UIImage                                *currentGoodsImage;

+ (instancetype)instanceWithViewController:(JMBaseViewController *)containerViewController;

- (void)scrollingWithView:(UIScrollView *)scrollView;

- (void)playVideo;

@end
