//
//  YYAlertGridView.h
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAlertGridView;

typedef void (^YYAlertGridViewDidClickedBlock)(YYAlertGridView *alertGrid, NSInteger index);


@interface YYAlertGridView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//标题
@property (nonatomic, copy) NSString *title;

//选择的内容
@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, copy) YYAlertGridViewDidClickedBlock didClickedBlock;

+ (instancetype)showWithTextArry:(NSArray *)textArry;
- (instancetype)showWithTextArry:(NSArray *)textArry;
- (instancetype)show;


@end
