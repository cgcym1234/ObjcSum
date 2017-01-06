//
//  JMSkuSelectedViewModel+MiddleCollectionView.h
//  ObjcSum
//
//  Created by yangyuan on 2017/1/3.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel.h"



@interface JMSkuSelectedViewModel ()

@property (nonatomic, strong) JMSkuAdditionalInfoCellModel *skuAdditonalInfo;//4.1取消，先预留
@property (nonatomic, strong) NSArray<JMSkuGroupModel *> *skuGroupModels;

@property (nonatomic, strong) JMSkuNumSelectedCellModel *skuNumSelectedModel;

@end

@interface JMSkuSelectedViewModel (MiddleCollectionView)


/*section数据说明：
 0： 放附加信息数据 skuAdditonalInfos，可能为空
 1 ~ n-1: 放sku分组数据，可能有多个
 n: 放数量选择数据，可能为空
 section是固定存在的，section中的数据可能为空
 */
- (JMSkuSectionType)typeOfSection:(NSInteger)section;
- (NSInteger)sections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (UIEdgeInsets)contenInsetsForSection:(NSInteger)section;
- (CGFloat)minimumLineSpacingForSection:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;
- (id<JMComponentModel>)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath;
- (id<JMComponentModel>)headerDataForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark 重新计算JMSkuCellModel
/*根据SelectedCellItems字典重新计算库存*/
- (void)refreshCellModelsStockWithSelectedCellItems;

/*根据输入刷新数量选择model*/
- (void)refreshNumSelectedModelWithInputValue:(NSInteger)inputValue;
/*根据加减按钮刷新数量选择model*/
- (void)refreshNumSelectedModelWithAction:(JMSkuNumSelectedButtonAction)action;

@end
