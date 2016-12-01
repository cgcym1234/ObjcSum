//
//  JMGoodsDetailGoodsViewController.h
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailManager.h"

/** 重构版商品详情 商品列表VC*/
@interface JMGoodsDetailGoodsViewController : UIViewController


///< 数据源
//@property (nonatomic, strong) MAProduct                                  *product;
///< 选中的sku Id
@property (nonatomic, strong) NSString                                   *currentSku;

@property (nonatomic, weak) JMGoodsDetailManager *goodsDetailManager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 *  创建JMGoodsDetailContainerViewController视图控制器
 */
+ (instancetype)instanceFromStoryboard;

- (UIScrollView *)innerScrollView;

//默认的图片，用于加入购物车等动画
- (UIImage *)defaultGoodsImage;

//当前选中的image，用于分享等
- (UIImage *)currentGoodsImage;

// 刷新sku数据，头部相册，TableView数据源
- (void)reloadAll;

// 头部相册
- (void)reloadHeader;



//更新数据源
- (void)reloadList;


@end
