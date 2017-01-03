//
//  JMSkuSelectedViewModel+JMSku.h
//  ObjcSum
//
//  Created by yangyuan on 2017/1/2.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel.h"
#import "JMSkuModel.h"

@interface JMSkuSelectedViewModel ()

@property (nonatomic, strong) JMSkuModel *jmSkuModel;

//只存放选中的CellModel，以CellModel.group.type为key
@property (nonatomic, strong) NSMutableDictionary<NSString *, JMSkuCellModel *> *selectedCellItems;

@property (nonatomic, readonly) BOOL isSelectedAllGroup;
@property (nonatomic, weak, readonly) SkuInfo *locatedSkuInfo;
@property (nonatomic, readonly) NSInteger maxStockCurrent;

@end

@interface JMSkuSelectedViewModel (JMSku)

+ (instancetype)instanceWithSkuModel:(JMSkuModel *)skuModel;

+ (JMSkuModel *)requestData;

#pragma mark - 选中cellItem后重新计算流程
/*1. 更新SelectedCellItems字典和cellModel状态*/
- (void)didClickCellWithModel:(JMSkuCellModel *)currentCellModel;

- (NSString *)selectingTip;

@end
