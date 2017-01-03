//
//  JMSkuSelectedViewModel.h
//  ObjcSum
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JMComponent.h"
#import "JMSkuDisplayView.h"
#import "JMSkuAdditionalInfoCell.h"
#import "JMSkuGroupHeader.h"
#import "JMSkuCell.h"
#import "JMSkuNumSelectedCell.h"
#import "JMSkuConfirmView.h"
#import "JMSkuModel.h"

#define SkuAdditonalInfoSection 0

@interface JMSkuSelectedViewModel : NSObject<JMComponentModel>

@property (nonatomic, strong) JMSkuDisplayViewModel *skuDisplayModel;
@property (nonatomic, strong) JMSkuAdditionalInfoCellModel *skuAdditonalInfo;//4.1取消，先预留
@property (nonatomic, strong) NSArray<JMSkuGroupModel *> *skuGroupModels;
@property (nonatomic, strong) JMSkuNumSelectedCellModel *skuNumSelectedModel;
@property (nonatomic, strong) JMSkuConfirmViewModel *skuConfirmModel;

@property (nonatomic, strong) NSString *jumeiPrice;
@property (nonatomic, strong) NSString *goodsImage;


/*高度*/
+ (CGFloat)skuDisplayViewHeight;
+ (CGFloat)collectionViewHeight;
+ (CGFloat)skuConfirmViewHeight;
+ (CGFloat)viewWidth;

//屏幕宽度
@property (nonatomic, assign, readonly) CGFloat viewWidth;


/*section数据说明：
 0： 放附加信息数据 skuAdditonalInfos，可能为空
 1 ~ n-1: 放sku分组数据，可能有多个
 n: 放数量选择数据，可能为空
 section是固定存在的，section中的数据可能为空
 */
- (NSInteger)sections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath;
- (id<JMComponentModel>)dataForItemAtIndexPath:(NSIndexPath *)indexPath;


+ (instancetype)testData;

@end










