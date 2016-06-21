//
//  UIScrollView+YYRefresh.m
//  ObjcSum
//
//  Created by sihuan on 16/6/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIScrollView+YYRefresh.h"
#import <objc/runtime.h>

static char kYYRefreash;

@implementation UIScrollView (YYRefresh)

- (YYRefresh *)yyRefresh {
    return objc_getAssociatedObject(self, &kYYRefreash);
}
- (void)setYyRefresh:(YYRefresh *)yyRefresh {
    objc_setAssociatedObject(self, &kYYRefreash, yyRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler {
    return [self addYYRefreshAtPosition:position action:actionHandler config:nil];
}

- (YYRefresh *)addYYRefreshAtPosition:(YYRefreshPosition)position action:(void (^)(YYRefresh *refresh))actionHandler config:(YYRefreshConfig *)config {
    YYRefresh *refresh = [[YYRefresh alloc] initWithScrollView:self position:position action:actionHandler config:(YYRefreshConfig *)config];
    [self addSubview:refresh];
    return refresh;
}

@end
