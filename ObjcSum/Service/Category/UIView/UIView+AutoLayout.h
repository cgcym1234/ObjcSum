//
//  UIView+AutoLayout.h
//  NewSkills
//
//  Created by michael chen on 14/11/19.
//  Copyright (c) 2014年 huansi. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 模拟android的RelativeLayout,适用于同级view，和父子view之间
@interface UIView (AutoLayout)

#pragma mark - 控件上端与父控件的上端对齐,
- (void)layoutAlignParentTop:(CGFloat)offset;
#pragma mark - 控件底端与父控件的底端对齐,
- (void)layoutAlignParentBottom:(CGFloat)offset;
#pragma mark - 控件左端与父控件的左端对齐,
- (void)layoutAlignParentLeft:(CGFloat)offset;
#pragma mark - 控件右端与父控件的右端对齐,
- (void)layoutAlignParentRight:(CGFloat)offset;


#pragma mark - 控件高度
- (void)layoutHeight:(CGFloat)offset;
#pragma mark - 控件宽度
- (void)layoutWidth:(CGFloat)offset;

#pragma mark - 控件相对于其他view比例的高度
- (void)layoutHeightWithView:(UIView *)view scale:(CGFloat)scale of:(CGFloat)offset;
#pragma mark - 控件相对于其他view比例的宽度
- (void)layoutWidthWithView:(UIView *)view scale:(CGFloat)scale of:(CGFloat)offset;

#pragma mark - 控件最小高度
- (void)layoutMiniHeight:(CGFloat)offset;
#pragma mark - 控件最大高度
- (void)layoutMaxHeight:(CGFloat)offset;

#pragma mark - 控件最小宽度
- (void)layoutMiniWidth:(CGFloat)offset;
#pragma mark - 控件最大宽度
- (void)layoutMaxWidth:(CGFloat)offset;


- (void)layoutEqualParent;
#pragma mark - 当前控件位于父控件的横向中间位置（水平方向上的中间）
- (void)layoutCenterHorizontal;
#pragma mark - 当前控件位于父控件的纵横向中间位置（垂直方向上的中间）
- (void)layoutCenterVertical;
#pragma mark - 当前控件位于父控件的纵向中间位置（平面上的正中间）
- (void)layoutCenterInParent;


#pragma mark - 使当前控件位于指定控件的上方 offset 距离
- (void)layoutAbove:(UIView *)view of:(CGFloat)offset;
#pragma mark - 使当前控件位于指定控件的下方 offset 距离
- (void)layoutBelow:(UIView *)view of:(CGFloat)offset;
#pragma mark - 使当前控件位于指定控件的左方 offset 距离
- (void)layoutLeft:(UIView *)view of:(CGFloat)offset;
#pragma mark - 使当前控件位于指定控件的右方 offset 距离
- (void)layoutRight:(UIView *)view of:(CGFloat)offset;

#pragma mark - 将该控件的底部边缘与给定ID控件的底部边缘对齐, 效果和layoutAlignBottom一样了。。
- (void)layoutAlignBaseline:(UIView *)view;
#pragma mark - 将该控件的底部边缘与给定ID控件的底部边缘对齐
- (void)layoutAlignBottom:(UIView *)view;
#pragma mark - 将给定控件的顶部边缘与给定ID控件的顶部对齐
- (void)layoutAlignTop:(UIView *)view;
#pragma mark - 将该控件的左边缘与给定ID控件的左边缘对齐
- (void)layoutAlignLeft:(UIView *)view;
#pragma mark - 将该控件的右边缘与给定ID控件的右边缘对齐
- (void)layoutAlignRight:(UIView *)view;


#pragma mark - 设置Autoresizing

//保证和superView同样大小
- (void)setAutoresizingFillSuperView;


@end
