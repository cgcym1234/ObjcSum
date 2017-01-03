//
//  JMSkuSelectedView+SkuNumSelected.h
//  ObjcSum
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "JMSkuSelectedView.h"

/**< Sku数量选择，某些情况不显示 */
@interface JMSkuSelectedView ()

@property (nonatomic, strong) JMSkuNumSelectedCellModel *skuNumSelectedModel;
@property (nonatomic, weak) JMSkuNumSelectedCell *skuNumSelectedView;

@end


@interface JMSkuSelectedView (SkuNumSelected)


@end
