//
//  JMSimpleSegmentItem.h
//  JuMei
//
//  Created by yangyuan on 2016/9/27.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSimpleSegmentItemModel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailText;
//@property (nonatomic, assign) BOOL selected;

+ (instancetype)instanceWithText:(NSString *)text detailText:(NSString *)detailText;
@end

IB_DESIGNABLE
@interface JMSimpleSegmentItem : UIView

@property (nonatomic, strong) JMSimpleSegmentItemModel *model;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) IBInspectable UIColor *nomalColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;


+ (instancetype)instanceFromNib;
- (void)reloadWithModel:(JMSimpleSegmentItemModel *)model;

@end
