//
//  UIView+AutoLayout.m
//  NewSkills
//
//  Created by michael chen on 14/11/19.
//  Copyright (c) 2014年 huansi. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

#pragma mark - 系统方法理解
/**
 *  0、translatesAutoresizingMaskIntoConstraints：
 The translatesAutoresizingMaskIntoConstraints property is set to NO, so our constraints will not conflict with the old “springs and struts” method.
 1、NSLayoutConstraint类，是IOS6引入的，字面意思是“约束”、“限制”的意思，实现相对布局，就依靠这个类了；
 2、怎么理解这个方法调用：
 NSLayoutConstraint *constraint = [NSLayoutConstraint
 constraintWithItem:firstButton        firstButton是我们实例化的按钮
 attribute:NSLayoutAttributeLeading    firstButton的左边
 relatedBy:NSLayoutRelationEqual       firstButton的左边与self.view的左边的相对关系
 toItem:self.view                      指定firstButton的相对的对象是self.view
 attribute:NSLayoutAttributeLeading    相对与self.view的左边（NSLayoutAttributeLeading是左边的意思）
 multiplier:1.0f                                       （后文介绍）
 constant:20.f];                       firstButton左边相对self.view左边，向右边偏移了20.0f (根据IOS坐标系，向右和向下是正数)
 [self.view addConstraint:constraint]; 将这个约束添加到self.view上
 
 
 附视图的属性和关系的值:

 typedef NS_ENUM(NSInteger, NSLayoutRelation) {
 NSLayoutRelationLessThanOrEqual = -1,          //小于等于
 NSLayoutRelationEqual = 0,                     //等于
 NSLayoutRelationGreaterThanOrEqual = 1,        //大于等于
 };
 typedef NS_ENUM(NSInteger, NSLayoutAttribute) {
 NSLayoutAttributeLeft = 1,                     //左侧
 NSLayoutAttributeRight,                        //右侧
 NSLayoutAttributeTop,                          //上方
 NSLayoutAttributeBottom,                       //下方
 NSLayoutAttributeLeading,                      //首部
 NSLayoutAttributeTrailing,                     //尾部
 NSLayoutAttributeWidth,                        //宽度
 NSLayoutAttributeHeight,                       //高度
 NSLayoutAttributeCenterX,                      //X轴中心
 NSLayoutAttributeCenterY,                      //Y轴中心
 NSLayoutAttributeBaseline,                     //文本底标线
 
 NSLayoutAttributeNotAnAttribute = 0            //没有属性
 };
 
 NSLayoutAttributeLeft/NSLayoutAttributeRight 和 NSLayoutAttributeLeading/NSLayoutAttributeTrailing的区别是left/right永远是指左右，
 而leading/trailing在某些从右至左习惯的地区会变成，leading是右边，trailing是左边。(大概是⊙﹏⊙b)
 */

#pragma mark - 3 个view
- (void)setConstraintOnTarget:(id)target toItem:(id)view1 attribute:(NSLayoutAttribute)attr1 withItem:(id)view2 attribute:(NSLayoutAttribute)attr2 relatedBy:(NSLayoutRelation)relation multiplier:(CGFloat)multiplier constant:(CGFloat)c priority:(UILayoutPriority)priority
{
    NSLayoutConstraint *constrain = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    constrain.priority = priority;
    [target addConstraint:constrain];
}

#pragma mark - 2 个view
- (void)setConstraintOnTarget:(id)target toItem:(id)view attribute:(NSLayoutAttribute)attr relatedBy:(NSLayoutRelation)relation multiplier:(CGFloat)multiplier constant:(CGFloat)c priority:(UILayoutPriority)priority
{
    return [self setConstraintOnTarget:target toItem:view attribute:attr withItem:nil attribute:NSLayoutAttributeNotAnAttribute relatedBy:relation multiplier:multiplier constant:c priority:priority];
}


#pragma mark - 用于和superView添加约束
- (void)setConstrainWithParent:(NSLayoutAttribute)attr relatedBy:(NSLayoutRelation)relation  multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
    //默认是UILayoutPriorityRequired，这里设置低一些，方便miniHeight等约束优先生效
    return [self setConstraintOnTarget:self.superview toItem:self attribute:attr withItem:self.superview attribute:attr relatedBy:relation multiplier:multiplier constant:constant priority:UILayoutPriorityDefaultHigh];
}

//- (void)setConstrainWithParent:(NSLayoutAttribute)attr relatedBy:(NSLayoutRelation)relation constant:(CGFloat)constant
//{
//    return [self setConstrainWithParent:attr relatedBy:relation multiplier:1.0 constant:constant];
//}

- (void)setConstrainWithParent:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    if (!self.superview) {
        return;
    }
    return [self setConstrainWithParent:attr relatedBy:NSLayoutRelationEqual multiplier:1.0 constant:constant];
}


#pragma mark - 控件上端与父控件的上端对齐,
- (void)layoutAlignParentTop:(CGFloat)offset
{
    return [self setConstrainWithParent:NSLayoutAttributeTop constant:offset];
}

#pragma mark - 控件底端与父控件的底端对齐,
- (void)layoutAlignParentBottom:(CGFloat)offset
{
    return [self setConstrainWithParent:NSLayoutAttributeBottom constant:-offset];
}

#pragma mark - 控件左端与父控件的左端对齐,
- (void)layoutAlignParentLeft:(CGFloat)offset
{
    return [self setConstrainWithParent:NSLayoutAttributeLeft constant:offset];
}

#pragma mark - 控件右端与父控件的右端对齐,
- (void)layoutAlignParentRight:(CGFloat)offset
{
    return [self setConstrainWithParent:NSLayoutAttributeRight constant:-offset];
}




#pragma mark - 给自己添加约束
- (void)setConstrain:(NSLayoutAttribute)attr relatedBy:(NSLayoutRelation)relation constant:(CGFloat)constant
{
    return [self setConstraintOnTarget:self toItem:self attribute:attr relatedBy:relation multiplier:1.0 constant:constant priority:UILayoutPriorityRequired];
}

#pragma mark - 控件高度
- (void)layoutHeight:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual constant:offset];
}
#pragma mark - 控件宽度
- (void)layoutWidth:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual constant:offset];
}

#pragma mark - 控件相对于其他view比例的高度
- (void)layoutHeightWithView:(UIView *)view scale:(CGFloat)scale of:(CGFloat)offset
{
    return [self setConstraintOnTarget:self.superview toItem:self attribute:NSLayoutAttributeHeight withItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual multiplier:scale constant:offset priority:UILayoutPriorityRequired];
}
#pragma mark - 控件相对于其他view比例的宽度
- (void)layoutWidthWithView:(UIView *)view scale:(CGFloat)scale of:(CGFloat)offset
{
    return [self setConstraintOnTarget:self.superview toItem:self attribute:NSLayoutAttributeWidth withItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual multiplier:scale constant:offset priority:UILayoutPriorityRequired];
}

#pragma mark - 控件最小高度
- (void)layoutMiniHeight:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual constant:offset];
}
#pragma mark - 控件最大高度
- (void)layoutMaxHeight:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual constant:offset];
}

#pragma mark - 控件最小宽度
- (void)layoutMiniWidth:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual constant:offset];
}
#pragma mark - 控件最大宽度
- (void)layoutMaxWidth:(CGFloat)offset
{
    return [self setConstrain:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual constant:offset];
}




#pragma mark - 当前控件位于父控件的横向中间位置（水平方向上的中间）
- (void)layoutCenterHorizontal
{
    return [self setConstrainWithParent:NSLayoutAttributeCenterX constant:0];
}

#pragma mark - 当前控件位于父控件的纵横向中间位置（垂直方向上的中间）
- (void)layoutCenterVertical
{
    return [self setConstrainWithParent:NSLayoutAttributeCenterY constant:0];
}

#pragma mark - 当前控件位于父控件的纵向中间位置（平面上的正中间）
- (void)layoutCenterInParent
{
    [self layoutCenterHorizontal];
    [self layoutCenterVertical];
}


#pragma mark - 控件和父控件保持一样的大小与位置
- (void)layoutEqualParent {
    [self layoutAlignParentTop:0];
    [self layoutAlignParentBottom:0];
    [self layoutAlignParentLeft:0];
    [self layoutAlignParentRight:0];
}

#pragma mark - 用于调整2个同级或父子view之间的位置
- (void)setAttribute:(NSLayoutAttribute)attr1 withItem:(id)view2 attribute:(NSLayoutAttribute)attr2 constant:(CGFloat)c
{
    return [self setConstraintOnTarget:self.superview toItem:self attribute:attr1 withItem:view2 attribute:attr2 relatedBy:NSLayoutRelationEqual multiplier:1.0 constant:c priority:UILayoutPriorityRequired];
}

#pragma mark - 使当前控件位于指定控件的上方 offset 距离
- (void)layoutAbove:(UIView *)view of:(CGFloat)offset
{
    return [self setAttribute:NSLayoutAttributeBottom withItem:view attribute:NSLayoutAttributeTop constant:-offset];
}
#pragma mark - 使当前控件位于指定控件的下方 offset 距离
- (void)layoutBelow:(UIView *)view of:(CGFloat)offset
{
    return [self setAttribute:NSLayoutAttributeTop withItem:view attribute:NSLayoutAttributeBottom constant:offset];
}
#pragma mark - 使当前控件位于指定控件的左方 offset 距离
- (void)layoutLeft:(UIView *)view of:(CGFloat)offset
{
    return [self setAttribute:NSLayoutAttributeRight withItem:view attribute:NSLayoutAttributeLeft constant:-offset];
}
#pragma mark - 使当前控件位于指定控件的右方 offset 距离
- (void)layoutRight:(UIView *)view of:(CGFloat)offset
{
    return [self setAttribute:NSLayoutAttributeLeft withItem:view attribute:NSLayoutAttributeRight constant:offset];
}

#pragma mark - 将该控件的底部边缘与给定ID控件的底部边缘对齐
- (void)layoutAlignBaseline:(UIView *)view
{
    return [self setAttribute:NSLayoutAttributeBaseline withItem:view attribute:NSLayoutAttributeBaseline constant:0];
}
#pragma mark - 将该控件的底部边缘与给定ID控件的底部边缘对齐
- (void)layoutAlignBottom:(UIView *)view
{
    return [self setAttribute:NSLayoutAttributeBottom withItem:view attribute:NSLayoutAttributeBottom constant:0];
}
#pragma mark - 将给定控件的顶部边缘与给定ID控件的顶部对齐
- (void)layoutAlignTop:(UIView *)view
{
    return [self setAttribute:NSLayoutAttributeTop withItem:view attribute:NSLayoutAttributeTop constant:0];
}
#pragma mark - 将该控件的左边缘与给定ID控件的左边缘对齐
- (void)layoutAlignLeft:(UIView *)view
{
    return [self setAttribute:NSLayoutAttributeLeft withItem:view attribute:NSLayoutAttributeLeft constant:0];
}
#pragma mark - 将该控件的右边缘与给定ID控件的右边缘对齐
- (void)layoutAlignRight:(UIView *)view
{
    return [self setAttribute:NSLayoutAttributeRight withItem:view attribute:NSLayoutAttributeRight constant:0];
}




#pragma mark - 设置Autoresizing

- (void)setAutoresizingFillSuperView {
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
}

@end

















