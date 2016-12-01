//
//  JMGoodsDetailContainerViewController+Network.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController+Network.h"
#import "JMGoodsDetailContainerViewController+NavigationBar.h"
#import "JMGoodsDetailContainerViewController+ShoppingCat.h"
#import "JMGoodsDetail.h"

@implementation JMGoodsDetailContainerViewController (Network)

- (void)stopLoadingAll {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - cancelAllRequest

- (void)cancelAllRequest {
    
}

#pragma mark - 入口

- (void)requestData {
    
}


@end
