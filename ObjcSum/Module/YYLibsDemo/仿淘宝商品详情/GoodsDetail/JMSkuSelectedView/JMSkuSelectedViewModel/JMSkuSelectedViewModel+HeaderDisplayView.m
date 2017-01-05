//
//  JMSkuSelectedViewModel+HeaderDisplayView.m
//  ObjcSum
//
//  Created by yangyuan on 2017/1/3.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "JMSkuSelectedViewModel+HeaderDisplayView.h"

@implementation JMSkuSelectedViewModel (HeaderDisplayView)

#pragma mark - DisplayingModel

/*更新头部展示model*/
- (void)refreshDisplayingModelWithSelectedCellItems {
    self.skuDisplayModel.skuImageName = [self goodsImageCurrent];
    self.skuDisplayModel.price = [[self priceCurrent] priceDisplayText];
    self.skuDisplayModel.stock = [self stockCurrent];
    self.skuDisplayModel.selectingTip = [self selectingTipCurrent];
}

- (NSString *)goodsImageCurrent {
    SkuInfo *locatedSkuInfo = self.locatedSkuInfo;
    return  locatedSkuInfo ? locatedSkuInfo.img : self.goodsImage;
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
    
    for (SkuGroupInfo *group in self.jmSkuModel.skuGroupInfos) {
        JMSkuCellModel *cellModel = self.selectedCellItems[group.type];
        if (isSelectedAllGroup) {
            [tip appendString:@" "];
            [tip appendString:cellModel.text];
        } else {
            if (!cellModel) {
                [tip appendString:@" "];
                [tip appendString:group.title];
            }
        }
    }
    
    return tip;
}

@end
