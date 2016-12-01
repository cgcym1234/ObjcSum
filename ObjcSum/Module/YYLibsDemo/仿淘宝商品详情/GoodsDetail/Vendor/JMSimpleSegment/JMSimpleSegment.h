//
//  JMSimpleSegment.h
//  JuMei
//
//  Created by yangyuan on 2016/9/27.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSimpleSegmentItem.h"

@class JMSimpleSegment;

typedef void (^JMSimpleSegmentDidClickBlock)(JMSimpleSegment *view, NSInteger index);

/**< 简单的分段显示器 */
@interface JMSimpleSegment : UIView

//数据源
@property (nonatomic, strong) NSArray<JMSimpleSegmentItemModel *> *itemModels;

/**
 Index of the currently selected segment.
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, copy) JMSimpleSegmentDidClickBlock didClickBlock;

//only
- (instancetype)initWithItemModels:(NSArray<JMSimpleSegmentItemModel *> *)itemModels;


@end
