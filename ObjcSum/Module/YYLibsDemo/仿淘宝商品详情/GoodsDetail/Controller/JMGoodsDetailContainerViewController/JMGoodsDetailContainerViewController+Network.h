//
//  JMGoodsDetailContainerViewController+Network.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailContainerViewController.h"

@interface JMGoodsDetailContainerViewController ()


@end

@interface JMGoodsDetailContainerViewController (Network)

- (void)cancelAllRequest;

//入口
- (void)requestData;


@end
