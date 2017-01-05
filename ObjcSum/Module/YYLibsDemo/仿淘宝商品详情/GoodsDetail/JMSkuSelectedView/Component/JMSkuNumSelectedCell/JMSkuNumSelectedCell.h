//
//  JMSkuNumSelectedCell.h
//  JuMei
//
//  Created by yangyuan on 2016/12/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMComponent.h"

@class JMSkuGroupModel;

@interface JMSkuNumSelectedCellModel : NSObject<JMComponentModel>

/*和skuCell使用同一种header*/
@property (nonatomic, strong) JMSkuGroupModel *header;
@property (nonatomic) NSUInteger num;

@property (nonatomic, assign) UIControlState minusButtonState;
@property (nonatomic, assign) UIControlState addButtonState;

//22
@property (nonatomic, assign, readonly) NSInteger viewHeight;
@end


typedef NS_ENUM(NSUInteger, JMSkuNumSelectedButtonAction) {
    JMSkuNumSelectedButtonActionNone = 110,
    JMSkuNumSelectedButtonActionMinus,
    JMSkuNumSelectedButtonActionAdd,
};

@class JMSkuNumSelectedCell;

@protocol JMSkuNumSelectedCellDelegate <NSObject>

@optional
- (void)jmSkuNumSelectedCell:(JMSkuNumSelectedCell *)cell didClickWithAction:(JMSkuNumSelectedButtonAction)action;
- (void)jmSkuNumSelectedCell:(JMSkuNumSelectedCell *)cell inputValueChanged:(NSString *)value;


@end

/**< 数量选择 */
@interface JMSkuNumSelectedCell : UICollectionViewCell<JMComponent>

@property (nonatomic, weak) IBOutlet UIButton *minusButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@property (nonatomic, strong) JMSkuNumSelectedCellModel *model;

@property (nonatomic, weak) id<JMSkuNumSelectedCellDelegate> delegate;

- (void)reloadData;
- (void)reloadWithData:(id<JMComponentModel>)model;

@end
