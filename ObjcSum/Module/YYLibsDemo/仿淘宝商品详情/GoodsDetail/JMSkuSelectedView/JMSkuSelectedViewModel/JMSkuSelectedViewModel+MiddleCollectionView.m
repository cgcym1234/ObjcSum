//
//  JMSkuSelectedViewModel+MiddleCollectionView.m
//  ObjcSum
//
//  Created by yangyuan on 2017/1/3.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel+MiddleCollectionView.h"

@implementation JMSkuSelectedViewModel (MiddleCollectionView)

#pragma mark - Public

/*section数据说明：
 0： 放附加信息数据 skuAdditonalInfos，可能为空
 1 ~ n-1: 放sku分组数据，可能有多个
 n: 放数量选择数据，可能为空
 section是固定存在的，section中的数据可能为空
 */
- (JMSkuSectionType)typeOfSection:(NSInteger)section {
    if (section == 0) {
        return JMSkuSectionTypeAdditional;
    } else if (section == self.sections - 1) {
        return JMSkuSectionTypeNumSelected;
    } else {
        return JMSkuSectionTypeSkuGroup;
    }
}

- (NSInteger)sections {
    return 1 + self.skuGroupModels.count + 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeAdditional:
            return self.skuAdditonalInfo == nil ? 0 : 1;
            
        case JMSkuSectionTypeNumSelected:
            return self.skuNumSelectedModel == nil ? 0 : 1;
            
        case JMSkuSectionTypeSkuGroup: {
            NSInteger skuGroupIndex = section - 1;
            return self.skuGroupModels[skuGroupIndex].cellModels.count;
        }
    }
}

- (UIEdgeInsets)contenInsetsForSection:(NSInteger)section {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeSkuGroup: {
            insets = UIEdgeInsetsMake(0, JMSkuSelectedViewPaddingLeftRight, JMSkuSelectedViewSkuItemSpacing, JMSkuSelectedViewPaddingLeftRight);
            break;
        }
        case JMSkuSectionTypeNumSelected:
            insets = UIEdgeInsetsMake(0, 0, JMSkuSelectedViewSkuItemSpacing, 0);
            break;
        default:
            insets = UIEdgeInsetsZero;
    }
    return insets;
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section {
    CGFloat spacing = 0;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeSkuGroup: {
            spacing = JMSkuSelectedViewSkuLineSpacing;
            break;
        }
        default:
            spacing = 0;
            
    }
    return spacing;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section {
    CGFloat spacing = 0;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeSkuGroup: {
            spacing = JMSkuSelectedViewSkuItemSpacing;
            break;
        }
        default:
            spacing = 0;
            
    }
    return spacing;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    //除了用于选择的skuButton，其他都是很view一样宽度
    CGFloat width = [[self class] viewWidth];
    NSInteger section = indexPath.section;
    
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeAdditional:
            height = self.skuAdditonalInfo.viewHeight;
            break;
            
        case JMSkuSectionTypeNumSelected:
            height = self.skuNumSelectedModel.viewHeight;
            break;
            
        case JMSkuSectionTypeSkuGroup: {
            JMSkuCellModel *skuModel = [self cellDataForItemAtIndexPath:indexPath];
            width = skuModel.viewWidth;
            height = skuModel.viewHeight;
            break;
        }
    }
    
    return CGSizeMake(width, height);
}

- (NSString *)cellIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeAdditional:
            return [JMSkuAdditionalInfoCell jm_identifier];
            
        case JMSkuSectionTypeNumSelected:
            return [JMSkuNumSelectedCell jm_identifier];
            
        case JMSkuSectionTypeSkuGroup: {
            return [JMSkuCell jm_identifier];
        }
    }
}

- (id<JMComponentModel>)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeAdditional:
            return self.skuAdditonalInfo;
            
        case JMSkuSectionTypeNumSelected:
            return self.skuNumSelectedModel;
            
        case JMSkuSectionTypeSkuGroup: {
            NSInteger skuGroupIndex = section - 1;
            NSInteger row = indexPath.item;
            return self.skuGroupModels[skuGroupIndex].cellModels[row];
        }
    }
}

- (id<JMComponentModel>)headerDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    switch ([self typeOfSection:section]) {
        case JMSkuSectionTypeAdditional:
            return nil;
            
        case JMSkuSectionTypeNumSelected:
            return self.skuNumSelectedModel.header;
            
        case JMSkuSectionTypeSkuGroup: {
            NSInteger skuGroupIndex = section - 1;
            return self.skuGroupModels[skuGroupIndex];
        }
    }
}

#pragma mark 重新计算JMSkuCellModel
/*根据SelectedCellItems字典重新计算库存*/
- (void)refreshCellModelsStockWithSelectedCellItems {
    for (JMSkuGroupModel *group in self.skuGroupModels) {
        NSMutableDictionary *valuesFilter = [self.selectedCellItems mutableCopy];
        
        if (valuesFilter[group.type]) {
            //同一维度不过滤
            valuesFilter[group.type] = nil;
        }
        
        [self caculateStockInGroup:group valuesFilter:valuesFilter];
    }
}

/*计算每个维度的库存*/
- (void)caculateStockInGroup:(JMSkuGroupModel *)group valuesFilter:(NSDictionary<NSString *, JMSkuCellModel *> *)filter {
    for (JMSkuCellModel *cellModel in group.cellModels) {
        [self caculateStockInCell:cellModel valuesFilter:filter];
    }
}

/*计算一个维度里每个cell的库存*/
- (void)caculateStockInCell:(JMSkuCellModel *)cellModel valuesFilter:(NSDictionary<NSString *, JMSkuCellModel *> *)filter {
    [cellModel.skuInfosFiltered removeAllObjects];
    /*取出带某个属性，比如 红色 的所有SkuInfo*/
    NSArray *valueSkuInfos = self.jmSkuModel.skuValueModelsDict[cellModel.text];
    NSInteger stock = 0;
    for (SkuInfo *skuInfo in valueSkuInfos) {
        __block BOOL isMatching = YES;
        //根据选中的value过滤
        [filter enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull typeKey, JMSkuCellModel * _Nonnull typeValueCell, BOOL * _Nonnull stop) {
            if (![typeValueCell.text isEqualToString:skuInfo.skuTypeValus[typeKey]]) {
                isMatching = NO;
                *stop = YES;
            }
        }];
        //不匹配选中属性的话，不参与库存计算
        if (!isMatching) {
            continue;
        }
        stock += skuInfo.stock;
        [cellModel.skuInfosFiltered addObject:skuInfo];
    }
    
    if (stock <= 0) {
        cellModel.state = UIControlStateDisabled;
    } else {
        /*不改变选中cell的状态*/
        if (cellModel.state == UIControlStateDisabled) {
            cellModel.state = UIControlStateNormal;
        }
    }
    cellModel.stock = stock;
}

/*根据输入刷新数量选择model*/
- (void)refreshNumSelectedModelWithInputValue:(NSInteger)inputValue {
    self.skuNumSelectedModel.num = inputValue;
    [self refreshNumSelectedModelWithAction:JMSkuNumSelectedButtonActionNone];
}

/*根据加减按钮刷新数量选择model*/
- (void)refreshNumSelectedModelWithAction:(JMSkuNumSelectedButtonAction)action {
    if (!self.skuNumSelectedModel) {
        return;
    }
    
    self.skuNumSelectedModel.minusButtonState = UIControlStateNormal;
    self.skuNumSelectedModel.addButtonState = UIControlStateNormal;
    
    if (action == JMSkuNumSelectedButtonActionAdd) {
        self.skuNumSelectedModel.num += 1;
    } else if (action == JMSkuNumSelectedButtonActionMinus) {
        self.skuNumSelectedModel.num -= 1;
    }
    
    //下面只考虑禁止点击的情况
    NSInteger maxStock = self.maxStockCurrent;
    
    if (maxStock <= 1) {
        self.skuNumSelectedModel.num = maxStock;
        self.skuNumSelectedModel.minusButtonState = UIControlStateDisabled;
        self.skuNumSelectedModel.addButtonState = UIControlStateDisabled;
    } else {
        
        NSInteger selectedNum = self.skuNumSelectedModel.num;
        if (selectedNum <= 1) {
            self.skuNumSelectedModel.num = 1;
            self.skuNumSelectedModel.minusButtonState = UIControlStateDisabled;
        } else {
            if (selectedNum >= maxStock) {
                self.skuNumSelectedModel.num = maxStock;
                self.skuNumSelectedModel.addButtonState = UIControlStateDisabled;
            }
        }
    }
}

@end
