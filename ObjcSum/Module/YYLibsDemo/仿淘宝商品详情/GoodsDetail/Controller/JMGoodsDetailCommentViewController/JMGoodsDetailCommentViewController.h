//
//  JMGoodsDetailCommentViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/26.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"

typedef enum : NSInteger {
    JMGoodsDetailCommentTypeAll = 0, ///< 全部评价
    JMGoodsDetailCommentTypePositive, ///< 好评
    JMGoodsDetailCommentTypeModerate, ///< 中评
    JMGoodsDetailCommentTypeNegative ///< 差评
} JMGoodsDetailCommentType;

/** 重构版商品详情 评论VC*/
@interface JMGoodsDetailCommentViewController : UIViewController

//@property (nonatomic, strong) MAProduct *product;
@property (nonatomic, assign) JMGoodsDetailCommentType defaultCommentType;

/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;

- (NSString *)commentTypeValue:(JMGoodsDetailCommentType)commentType;

- (void)reloadData;

@end













