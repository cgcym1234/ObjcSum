//
//  JMGoodsDetailPageController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPageViewController.h"

typedef void(^JMGoodsDetailPageControllerIndexChangeBlockBlock)(UIViewController *controller, NSUInteger index);

/**< 详情页PageController */
@interface JMGoodsDetailPageController : YYPageViewController

@property (nonatomic, copy) JMGoodsDetailPageControllerIndexChangeBlockBlock  indexChangeBlock;
@property (nonatomic, assign) int prevIndex;

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers;
- (void)setSelectedControlerIndex:(NSUInteger)index notify:(BOOL)notify;
- (void)setScrollEnabled:(BOOL)enable;


@end
