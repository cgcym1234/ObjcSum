//
//  JMGoodsDetail.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#ifndef JMGoodsDetail_h
#define JMGoodsDetail_h

#pragma mark - 类型

#define JMGoodsDetailStoryboardName @"JMGoodsDetail"

#define GLOBAL_DEAL @"global_deal"

#define GLOBAL_KEY @"global"    // 海淘商品
#define JUMEI_KEY @"jumei"      // 聚美自营商品

#define DEAL_KEY @"deal"        // 团购商品
#define POP_KEY @"pop"          // 名品商品
#define MALL_KEY @"mall"        // 商城商品


typedef enum JMGoodsDetailPage : NSUInteger {
    JMGoodsDetailPageGoods = 0,///< 商品
    JMGoodsDetailPageGraphic = 1,///< 图文详情
    JMGoodsDetailPagePublicPraise = 2,///< 口碑
    JMGoodsDetailPageComment = 2,///< 评论
} JMGoodsDetailPage;




#endif /* JMGoodsDetail_h */
