//
//  JMSkuAdditionalInfoCell.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"


@interface JMSkuAdditionalInfoCellModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *mainText;
@property (nonatomic, copy) NSString *additionalText;

//42
@property (nonatomic, assign, readonly) NSInteger viewHeight;

@end

/**< 一些可能的附加信息，比如尺码助手等 */
@interface JMSkuAdditionalInfoCell : UICollectionViewCell<JMComponent>

@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

@property (nonatomic, strong) JMSkuAdditionalInfoCellModel *model;

- (void)reloadWithData:(id<JMComponentModel>)model;

@end
