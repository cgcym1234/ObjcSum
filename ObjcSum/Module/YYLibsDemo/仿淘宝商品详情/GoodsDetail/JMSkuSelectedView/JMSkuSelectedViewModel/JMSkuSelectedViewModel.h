//
//  JMSkuSelectedViewModel.h
//  ObjcSum
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Additionals.h"
#import "NSString+TransformToDisplay.h"
#import "UIView+JMCategory.h"
#import "JMComponent.h"
#import "JMSkuDisplayView.h"
#import "JMSkuAdditionalInfoCell.h"
#import "JMSkuGroupHeader.h"
#import "JMSkuCell.h"
#import "JMSkuNumSelectedCell.h"
#import "JMSkuConfirmView.h"
#import "JMSkuModel.h"
#import "JMSkuSelectedViewConsts.h"

#define SkuAdditonalInfoSection 0

@interface JMSkuSelectedViewModel : NSObject<JMComponentModel>

@property (nonatomic, strong) JMSkuModel *jmSkuModel;

/*只存放选中的CellModel，以CellModel.group.type为key*/
@property (nonatomic, strong) NSMutableDictionary<NSString *, JMSkuCellModel *> *selectedCellItems;

@property (nonatomic, readonly) BOOL isSelectedAllGroup;

/*locatedSkuInfo不为空时为改sku库存，否则是所有sku的库存*/
@property (nonatomic, readonly) NSInteger maxStockCurrent;

/*选中全部的属性能定位到某个sku时候，不为空*/
@property (nonatomic, readonly) SkuInfo *locatedSkuInfo;

/* 选择的数量，
 如果没有选择数量view，为1(库存大于0)或者0 */
@property (nonatomic, readonly) NSInteger numSelected;

/*高度*/
+ (CGFloat)skuDisplayViewHeight;
+ (CGFloat)collectionViewHeight;
+ (CGFloat)skuConfirmViewHeight;
+ (CGFloat)viewWidth;

+ (instancetype)instanceWithSkuModel:(JMSkuModel *)skuModel;

#pragma mark - 选中cellItem后重新计算流程
/*根据选中的cellModel更新所有数据
 1. SelectedCellItems
 2. 所有cell状态
 3. DisplayingView
 */
- (void)refreshWithSelectedCellModel:(JMSkuCellModel *)selectedCellModel;

@end










