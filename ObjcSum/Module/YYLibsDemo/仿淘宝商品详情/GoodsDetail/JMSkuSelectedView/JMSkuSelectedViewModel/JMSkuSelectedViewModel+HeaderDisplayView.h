//
//  JMSkuSelectedViewModel+HeaderDisplayView.h
//  ObjcSum
//
//  Created by yangyuan on 2017/1/3.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel.h"

@interface JMSkuSelectedViewModel ()

@property (nonatomic, strong) JMSkuDisplayViewModel *skuDisplayModel;

@property (nonatomic, strong) NSString *jumeiPrice;
@property (nonatomic, strong) NSString *goodsImage;


@end

@interface JMSkuSelectedViewModel (HeaderDisplayView)

/*更新头部展示model*/
- (void)refreshDisplayingModelWithSelectedCellItems;

@end
