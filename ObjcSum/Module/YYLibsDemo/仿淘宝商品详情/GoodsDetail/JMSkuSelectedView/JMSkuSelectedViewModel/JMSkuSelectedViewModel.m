//
//  JMSkuSelectedViewModel.m
//  ObjcSum
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel.h"
#import "UIView+JMCategory.h"
#import "JMSkuSelectedViewConsts.h"
#import "JMSkuModel.h"
#import "JMSkuSelectedViewModel+JMSku.h"

@implementation JMSkuSelectedViewModel

#pragma mark - Initialization







#pragma mark - Public

/*section数据说明：
 0： 放附加信息数据 skuAdditonalInfos，可能为空
 1 ~ n-1: 放sku分组数据，可能有多个
 n: 放数量选择数据，可能为空
 section是固定存在的，section中的数据可能为空
 */
- (NSInteger)sections {
    return 1 + _skuGroupModels.count + 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (section == SkuAdditonalInfoSection) {
        return _skuAdditonalInfo == nil ? 0 : 1;
    }
    
    //
    if (section == self.sections - 1) {
        return _skuNumSelectedModel == nil ? 0 : 1;
    }
    
    NSInteger skuGroupIndex = section - 1;
    return _skuGroupModels[skuGroupIndex].cellModels.count;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    //除了用于选择的skuButton，其他都是很view一样宽度
    CGFloat width = [[self class] viewWidth];
    NSInteger section = indexPath.section;
    if (section == 0) {
        height = _skuAdditonalInfo.viewHeight;
    } else if (section == self.sections - 1) {
        height = _skuNumSelectedModel.viewHeight;
    } else {
        JMSkuCellModel *skuModel = [self dataForItemAtIndexPath:indexPath];
        width = skuModel.viewWidth;
        height = skuModel.viewHeight;
    }
    return CGSizeMake(width, height);
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == SkuAdditonalInfoSection) {
        return [JMSkuAdditionalInfoCell jm_identifier];
    }
    
    //
    if (section == self.sections - 1) {
        return [JMSkuNumSelectedCell jm_identifier];
    }
    
    return [JMSkuCell jm_identifier];
}

- (id<JMComponentModel>)dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == SkuAdditonalInfoSection) {
        return _skuAdditonalInfo;
    }
    
    //
    if (section == self.sections - 1) {
        return _skuNumSelectedModel;
    }
    
    NSInteger skuGroupIndex = section - 1;
    NSInteger row = indexPath.item;
    return _skuGroupModels[skuGroupIndex].cellModels[row];
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


@end
