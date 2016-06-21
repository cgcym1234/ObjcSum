//
//  YYRefreshView.h
//  ObjcSum
//
//  Created by sihuan on 2016/6/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefreshConfig.h"
#import "YYRefreshConst.h"

@interface YYRefreshView : UIView

- (instancetype)initWithConfig:(YYRefreshConfig *)config postion:(YYRefreshPosition)postion;

- (void)showIdleWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated;
- (void)showRedayWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated;
- (void)showRefreshingWithConfig:(YYRefreshConfig *)config animated:(BOOL)animated;


@end
