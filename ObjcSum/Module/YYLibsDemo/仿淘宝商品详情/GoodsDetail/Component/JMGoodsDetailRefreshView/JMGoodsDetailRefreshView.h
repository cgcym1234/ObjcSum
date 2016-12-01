//
//  JMGoodsDetailRefreshView.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"
#import "YYRefreshConst.h"

/**< 图文详情页的下拉显示view */
@interface JMGoodsDetailRefreshView : UIView<YYRefreshView>

+ (instancetype)instanceFromNib;

- (void)showWithState:(YYRefreshState)state config:(YYRefreshConfig *)config animated:(BOOL)animated;

@end
