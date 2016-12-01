//
//  JMGoodsDetailNavTitleView.h
//  JuMei
//
//  Created by yangyuan on 2016/9/28.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMGoodsDetailNavTitleView;

typedef void(^JMGoodsDetailNavTitleViewIndexChangeBlockBlock)(NSInteger index);

/**< 详情页头部tab选择条 */
@interface JMGoodsDetailNavTitleView : UIView

@property (nonatomic, strong) NSArray<NSString *> * sectionTitles;
@property (nonatomic, copy) NSString *title;

@property(nonatomic, assign) NSInteger selectedSegmentIndex;

//最多会显示多少个sectionTitles，用于自动计算宽度
@property(nonatomic, assign) NSInteger sectionTitleMaxCount;

@property (nonatomic, copy) JMGoodsDetailNavTitleViewIndexChangeBlockBlock indexChangeBlock;

+ (instancetype)instanceFromNib;

- (void)showSectionTilesAnimated;
- (void)switchTitleAnimated;

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end
