//
//  JMSkuCell.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"
#import "SkuInfo.h"

@class JMSkuGroupModel;

@interface JMSkuCellModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIControlState state;
//25
@property (nonatomic, assign, readonly) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;


@property (nonatomic, weak) JMSkuGroupModel *group;
@property (nonatomic, strong) NSMutableArray<SkuInfo *> *skuInfosFiltered;
@property (nonatomic) NSInteger stock;


@end

@class JMSkuCell;

@protocol JMSkuCellDelegate <NSObject>

- (void)jmSkuCellDidClicked:(JMSkuCell *)cell;

@end

/**< Sku选择button */
@interface JMSkuCell : UICollectionViewCell<JMComponent>

@property (nonatomic, weak) IBOutlet UIButton *skuButton;
@property (nonatomic, strong) JMSkuCellModel *model;
@property (nonatomic, weak) id<JMSkuCellDelegate> delegate;

- (void)reloadWithData:(id<JMComponentModel>)model;

@end
