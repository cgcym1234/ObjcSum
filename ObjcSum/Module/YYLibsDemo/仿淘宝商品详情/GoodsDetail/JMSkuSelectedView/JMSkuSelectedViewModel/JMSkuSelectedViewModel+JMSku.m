//
//  JMSkuSelectedViewModel+JMSku.m
//  ObjcSum
//
//  Created by yangyuan on 2017/1/2.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel+JMSku.h"
#import "NSObject+Additionals.h"

@implementation JMSkuSelectedViewModel (JMSku)

+ (instancetype)instanceWithSkuModel:(JMSkuModel *)skuModel {
    return [[JMSkuSelectedViewModel alloc] initWithSkuModel:skuModel];
}

- (instancetype)init {
    self = [super init];
    if (self){
        self.selectedCellItems = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithSkuModel:(JMSkuModel *)skuModel {
    self = [super init];
    if (self) {
        self.selectedCellItems = [NSMutableDictionary new];
        self.jumeiPrice = @"6666666666666.66";
        self.jmSkuModel = skuModel;
        //
        JMSkuDisplayViewModel *skuDisplayModel = [JMSkuDisplayViewModel new];
        
        
        //skuGroupModels
        NSMutableArray *skuGroupModels = [NSMutableArray new];
        for (SkuGroupInfo *groupInfo in skuModel.skuGroupInfos) {
            JMSkuGroupModel *skuGroupModel = [JMSkuGroupModel new];
            skuGroupModel.groupName = groupInfo.title;
            skuGroupModel.type = groupInfo.type;
            
            //skuModels
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *itemName in groupInfo.items) {
                JMSkuCellModel *cellModel = [JMSkuCellModel new];
                cellModel.text = itemName;
                cellModel.viewWidth = 80;
                cellModel.group = skuGroupModel;
                [array addObject:cellModel];
            }
            
            skuGroupModel.cellModels = array;
            [skuGroupModels addObject:skuGroupModel];
        }
        
        //
        JMSkuNumSelectedCellModel *skuNumSelectedModel = [JMSkuNumSelectedCellModel new];
        skuNumSelectedModel.num = @"0";
        
        //
        JMSkuConfirmViewModel *skuConfirmModel = [JMSkuConfirmViewModel new];
        skuConfirmModel.text = @"加入购物车";
        
        self.skuDisplayModel = skuDisplayModel;
        self.skuGroupModels = skuGroupModels;
        self.skuNumSelectedModel = skuNumSelectedModel;
        self.skuConfirmModel = skuConfirmModel;
        
        [self didClickCellWithModel:nil];
    }
    
    return self;
}

+ (JMSkuModel *)requestData {
    NSString *mockData = [[NSBundle mainBundle] pathForResource:@"JMSkuMockData" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:mockData];
    JMSkuModel *skuModel = [[JMSkuModel alloc] initWithDictionary:dict];
    return skuModel;
}

#pragma mark - 选中cellItem后重新计算流程

/*1. 更新SelectedCellItems字典和cellModel状态*/
- (void)didClickCellWithModel:(JMSkuCellModel *)currentCellModel {
    if (currentCellModel) {
        NSString *groupTypeKey = currentCellModel.group.type;
        
        //如果之前有选中同类型的cell
        JMSkuCellModel *prevCellModel = self.selectedCellItems[groupTypeKey];
        if (prevCellModel) {
            //同一个cell，取消并从字典删除
            if (prevCellModel == currentCellModel) {
                currentCellModel.state = UIControlStateNormal;
                self.selectedCellItems[groupTypeKey] = nil;
            } else {
                //不同，取消之前的，选中当前
                prevCellModel.state = UIControlStateNormal;
                currentCellModel.state = UIControlStateSelected;
                self.selectedCellItems[groupTypeKey] = currentCellModel;
            }
        } else {
            currentCellModel.state = UIControlStateSelected;
            self.selectedCellItems[groupTypeKey] = currentCellModel;
        }
    }
    
    [self refreshCellModelsStockWithSelectedCellItems];
    [self refreshDisplayingModelWithSelectedCellItems];
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

#pragma mark - DisplayingModel

/*更新头部展示model*/
- (void)refreshDisplayingModelWithSelectedCellItems {
    self.skuDisplayModel.price = [self priceCurrent];
    self.skuDisplayModel.stock = [self stockCurrent];
    self.skuDisplayModel.selectingTip = [self selectingTipCurrent];
}

- (NSString *)priceCurrent {
    SkuInfo *locatedSkuInfo = self.locatedSkuInfo;
    return  locatedSkuInfo ? locatedSkuInfo.jumeiPrice : self.jumeiPrice;
}

- (NSString *)stockCurrent {
    return [NSString stringWithFormat:@"库存%@%@", @(self.maxStockCurrent), self.jmSkuModel.unit];
}

- (NSString *)selectingTipCurrent {
    BOOL isSelectedAllGroup = self.isSelectedAllGroup;
    NSMutableString *tip = [NSMutableString stringWithString:isSelectedAllGroup ? @"已选": @"请选择"];
    
    for (JMSkuGroupModel *group in self.skuGroupModels) {
        JMSkuCellModel *cellModel = self.selectedCellItems[group.type];
        if (isSelectedAllGroup) {
            [tip appendString:@" "];
            [tip appendString:cellModel.text];
        } else {
            if (!cellModel) {
                [tip appendString:@" "];
                [tip appendString:group.groupName];
            }
        }
    }
    
    return tip;
}

#pragma mark - Getter

- (BOOL)isSelectedAllGroup {
    return [self.selectedCellItems allKeys].count == self.skuGroupModels.count;
}

- (SkuInfo *)locatedSkuInfo {
    return self.isSelectedAllGroup ? [self.selectedCellItems allValues].firstObject.skuInfosFiltered.firstObject : nil;
}

- (NSInteger)maxStockCurrent {
    SkuInfo *locatedSkuInfo = self.locatedSkuInfo;
    return locatedSkuInfo ?  locatedSkuInfo.stock : self.jmSkuModel.stock;
}


@end

