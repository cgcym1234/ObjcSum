//
//  JMSkuSelectedViewModel.m
//  ObjcSum
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel.h"
#import "JMSkuSelectedView.h"
#import "JMSkuSelectedViewConsts.h"
#import "JMSkuModel.h"
#import "JMSkuSelectedViewModel+Network.h"
#import "JMSkuSelectedViewModel+HeaderDisplayView.h"
#import "JMSkuSelectedViewModel+MiddleCollectionView.h"
#import "JMSkuSelectedViewModel+BottomConfirmView.h"
#import "NSString+JMCategory.h"

@implementation JMSkuSelectedViewModel

#pragma mark - Initialization

+ (instancetype)instanceWithSkuModel:(JMSkuModel *)skuModel {
    if (!skuModel) {
        skuModel = [self requestData];
    }
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
        //skuDisplayModel
        JMSkuDisplayViewModel *skuDisplayModel = [JMSkuDisplayViewModel new];
        
        
        //skuGroupModels
        NSMutableArray *skuGroupModels = [NSMutableArray new];
        CGFloat maxCellWidth = [[self class] viewWidth] -  2 * JMSkuSelectedViewPaddingLeftRight;
        for (SkuGroupInfo *groupInfo in skuModel.skuGroupInfos) {
            JMSkuGroupModel *skuGroupModel = [JMSkuGroupModel new];
            skuGroupModel.groupName = groupInfo.title;
            skuGroupModel.type = groupInfo.type;
            skuGroupModel.canChangeImage = groupInfo.canChangeImage;
            //skuModels
            NSMutableArray *array = [NSMutableArray new];
            for (int i = 0; i < groupInfo.items.count; i++) {
                SkuGroupItem *item = groupInfo.items[i];
                NSString *itemName = item.value;
                JMSkuCellModel *cellModel = [JMSkuCellModel new];
                cellModel.text = itemName;
                cellModel.attributeImage = item.img;
                cellModel.viewWidth = MIN(maxCellWidth, ceilf([itemName widthForFont:JMSkuSelectedViewCellFont]) + 2*JMSkuSelectedViewPaddingLeftRight);
                cellModel.group = skuGroupModel;
                [array addObject:cellModel];
            }
            
            skuGroupModel.cellModels = array;
            [skuGroupModels addObject:skuGroupModel];
        }
        
        //
        JMSkuNumSelectedCellModel *skuNumSelectedModel = [JMSkuNumSelectedCellModel new];
        
        //
        JMSkuConfirmViewModel *skuConfirmModel = [JMSkuConfirmViewModel new];
        skuConfirmModel.text = @"加入购物车";
        
        self.skuDisplayModel = skuDisplayModel;
        self.skuGroupModels = skuGroupModels;
        self.skuNumSelectedModel = skuNumSelectedModel;
        self.skuConfirmModel = skuConfirmModel;
        
        [self refreshWithSelectedCellModel:nil];
    }
    
    return self;
}


#pragma mark - 选中cellItem后重新计算流程
/*根据选中的cellModel更新所有数据
 1. SelectedCellItems
 2. 所有cell状态
 3. DisplayingView
 */
- (void)refreshWithSelectedCellModel:(JMSkuCellModel *)selectedCellModel {
    if (selectedCellModel) {
        NSString *groupTypeKey = selectedCellModel.group.type;
        
        //如果之前有选中同类型的cell
        JMSkuCellModel *prevCellModel = self.selectedCellItems[groupTypeKey];
        if (prevCellModel) {
            //同一个cell，取消并从字典删除
            if (prevCellModel == selectedCellModel) {
                selectedCellModel.state = UIControlStateNormal;
                self.selectedCellItems[groupTypeKey] = nil;
            } else {
                //不同，取消之前的，选中当前
                prevCellModel.state = UIControlStateNormal;
                selectedCellModel.state = UIControlStateSelected;
                self.selectedCellItems[groupTypeKey] = selectedCellModel;
            }
        } else {
            selectedCellModel.state = UIControlStateSelected;
            self.selectedCellItems[groupTypeKey] = selectedCellModel;
        }
    }
    
    [self refreshCellModelsStockWithSelectedCellItems];
    
    [self refreshDisplayingModelWithSelectedCellItems];
    
    [self refreshNumSelectedModelWithAction:JMSkuNumSelectedButtonActionNone];
}



#pragma mark - Getter

+ (CGFloat)skuDisplayViewHeight {
    return [JMSkuDisplayViewModel viewHeight];
}
+ (CGFloat)collectionViewHeight {
    return 440 - self.skuDisplayViewHeight - self.skuConfirmViewHeight;
}
+ (CGFloat)skuConfirmViewHeight {
    return [JMSkuConfirmViewModel viewHeight];
}
+ (CGFloat)viewWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

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

- (NSInteger)numSelected {
    if (self.skuNumSelectedModel) {
        return self.skuNumSelectedModel.num;
    } else {
        return self.maxStockCurrent > 0 ? 1 : 0;
    }
}


@end
