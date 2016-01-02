//
//  UIViewController+NoDataTip.h
//  MyLibs
//
//  Created by michael chen on 14/12/10.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 显示无数据时的界面

@interface NoDataTip : UIView

@property (strong, nonatomic)  UILabel *tipLabel;
@property (strong, nonatomic)  UIImageView *tipImage;
@property (assign, nonatomic)  NSInteger tipLabelInterval;

- (void)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image;

@end

@interface UIViewController (NoDataTip)

- (NoDataTip *)noDataTipShow;
- (NoDataTip *)noDataTipShow:(NSString *)content;
- (NoDataTip *)noDataTipShow:(NSString *)content image:(UIImage *)image;
- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image;
- (void)noDataTipDismiss;

@end
