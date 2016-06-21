//
//  UIScrollView+YYRefresh.h
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRefresh.h"

@interface UIScrollView (YYRefresh)

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler;

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config;

@end
