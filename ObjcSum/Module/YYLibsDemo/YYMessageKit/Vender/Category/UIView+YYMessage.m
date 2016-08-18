//
//  UIView+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 15/12/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UIView+YYMessage.h"

@implementation UIView (YYMessage)

+ (instancetype)newInstanceFromNib {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:[self className] owner:nil options:nil];
    return nibViews.firstObject;
}
#pragma mark - 圆形设置

- (void)setRound:(BOOL)round {
    self.layer.cornerRadius = self.width/2;
    self.layer.masksToBounds = YES;
}

- (BOOL)round {
    return self.layer.cornerRadius == MIN(self.frame.size.width, self.frame.size.height)/2;
}

- (void)setToRounded {
    [self setToRounded:MIN(self.frame.size.width, self.frame.size.height)/2];
}
- (void)setToRounded:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.clipsToBounds = true;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.left + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
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

#pragma mark - 控件和父控件保持一样的大小与位置
- (void)layoutEqualParent {
    [self layoutAlignParentTop:0];
    [self layoutAlignParentBottom:0];
    [self layoutAlignParentLeft:0];
    [self layoutAlignParentRight:0];
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


@end
