//
//  JMSkuGroupHeader.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"
#import "JMSkuCell.h"

@interface JMSkuGroupModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *selectedItem;
@property (nonatomic, strong) NSArray<JMSkuCellModel *> *cellModels;



@end

/**< Sku的分组名，比如颜色，尺码等，SectionHeader方式实现 */
@interface JMSkuGroupHeader : UICollectionReusableView<JMComponent>

@property (nonatomic, weak) IBOutlet UILabel *skuGroupNameLabel;
@property (nonatomic, strong) JMSkuGroupModel *model;

- (void)reloadWithData:(id<JMComponentModel>)model;

//36
+ (CGFloat)viewHeight;
@end
