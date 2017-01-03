//
//  JMSkuNumSelectedCell.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"



@interface JMSkuNumSelectedCellModel : NSObject<JMComponentModel>

@property (nonatomic, copy) NSString *num;
@property (nonatomic, readonly) NSUInteger numInteger;

//22
@property (nonatomic, assign, readonly) NSInteger viewHeight;
@end

/**< 数量选择 */
@interface JMSkuNumSelectedCell : UICollectionViewCell<JMComponent>

@property (nonatomic, weak) IBOutlet UIButton *minusButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@property (nonatomic, strong) JMSkuNumSelectedCellModel *model;

- (void)reloadWithData:(id<JMComponentModel>)model;

@end
