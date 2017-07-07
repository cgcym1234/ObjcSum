//
//  TagViewUtils.m
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "TagViewUtils.h"
#import "MMAbstractView.h"
#import "TaggingView.h"
#import "MMBorderAttachView.h"
#import "MMTagModel.h"

@implementation TagViewUtils

+ (void)recursiveSetBorderWithView:(UIView*)view {
    if (![view conformsToProtocol:@protocol(MMAbstractView)]) {
        view.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        view.layer.borderColor = [UIColor greenColor].CGColor;
    }
    
    for (UIView* subView in view.subviews) {
        [self recursiveSetBorderWithView:subView];
    }
}

+ (void)recursiveShowTagWithView:(UIView*)view {
    if (![view conformsToProtocol:@protocol(MMAbstractView)]) {
        [self showTaggingViewWithView:view];
    }
    
    for (UIView* subView in view.subviews) {
        [self recursiveShowTagWithView:subView];
    }
}


+ (void)showTaggingViewWithView:(UIView*)view {
    
    // 注入测试边框View
    [self registerBorderTestViewWithView:view];
    
    NSMutableArray* viewFrameObjs = [NSMutableArray array];
    NSArray* subViews = view.subviews;
    for (UIView* subView in subViews) {
        // 过滤特殊的View，不属于注入的View
        if (![subView conformsToProtocol:@protocol(MMAbstractView)]) {
            if (subView.alpha<0.001f) {
                continue;
            }
            
            if (subView.frame.size.height <= 2) {
                continue;
            }
        }
        
        MMFrameObject* frameObj = [[MMFrameObject alloc] init];
        frameObj.frame = subView.frame;
        frameObj.attachedView = subView;
        [viewFrameObjs addObject:frameObj];
    }
    
    NSMutableArray<MMLine*>* lines = [NSMutableArray array];
    for (MMFrameObject* sourceFrameObj in viewFrameObjs) {
        for (MMFrameObject* targetFrameObj in viewFrameObjs) {
            
            // 过滤特殊的View
            if ([sourceFrameObj.attachedView conformsToProtocol:@protocol(MMAbstractView)]
                && [targetFrameObj.attachedView conformsToProtocol:@protocol(MMAbstractView)]) {
                continue;
            }
            
            // 寻找View的右边对应的其他View的左边
            MMLine* hLine = [self horizontalLineWithFrameObj1:sourceFrameObj frameObj2:targetFrameObj];
            if (hLine) {
                [lines addObject:hLine];
                [targetFrameObj.leftInjectedObjs addObject:hLine];
            }
            
            // 寻找View的下边对应的其他View的上边
            MMLine* vLine = [self verticalLineWithFrameObj1:sourceFrameObj frameObj2:targetFrameObj];
            if (vLine) {
                [lines addObject:vLine];
                [targetFrameObj.topInjectedObjs addObject:vLine];
            }
        }
    }
    
    // 查找重复的射入line
    // hLine:Y的差值小于某个值，leftInjectedObjs->取最小一条
    // vLine:X的差值小于某个值，topInjectedObjs->取最小一条
    CGFloat minValue = 5;
    for (MMFrameObject* sourceFrameObj in viewFrameObjs) {
        
        {
            // 排序：Y值：从大到小
            [sourceFrameObj.leftInjectedObjs sortUsingComparator:^NSComparisonResult(MMLine*  _Nonnull obj1, MMLine*  _Nonnull obj2) {
                return obj1.point1.point.y > obj2.point1.point.y;
            }];
            int i = 0;
            NSLog(@"\n\n");
            MMLine* baseLine, *compareLine;
            if (sourceFrameObj.leftInjectedObjs.count) {
                baseLine = sourceFrameObj.leftInjectedObjs[i];
            }
            while (i<sourceFrameObj.leftInjectedObjs.count) {
                NSLog(@"lineWidth = %.1f == ", baseLine.lineWidth);
                if (i + 1 < sourceFrameObj.leftInjectedObjs.count) {
                    compareLine = sourceFrameObj.leftInjectedObjs[i + 1];
                    
                    if (ABS(baseLine.point1.point.y - compareLine.point1.point.y) < minValue) {
                        // 移除长的一条
                        if (baseLine.lineWidth > compareLine.lineWidth) {
                            [lines removeObject:baseLine];
                            baseLine = compareLine;
                        } else {
                            [lines removeObject:compareLine];
                        }
                    } else {
                        baseLine = compareLine;
                    }
                }
                i++;
            }
        }
        
        {
            // 排序：X值从大到小
            [sourceFrameObj.topInjectedObjs sortUsingComparator:^NSComparisonResult(MMLine*  _Nonnull obj1, MMLine*  _Nonnull obj2) {
                return obj1.point1.point.x >
                obj2.point1.point.x;
            }];
            int j = 0;
            MMLine* baseLine, *compareLine;
            if (sourceFrameObj.topInjectedObjs.count) {
                baseLine = sourceFrameObj.topInjectedObjs[j];
            }
            while (j<sourceFrameObj.topInjectedObjs.count) {
                if (j + 1 < sourceFrameObj.topInjectedObjs.count) {
                    compareLine = sourceFrameObj.topInjectedObjs[j + 1];
                    
                    if (ABS(baseLine.point1.point.x - compareLine.point1.point.x) < minValue) {
                        // 移除长的一条
                        // 移除长的一条
                        if (baseLine.lineWidth > compareLine.lineWidth) {
                            [lines removeObject:baseLine];
                            baseLine = compareLine;
                        } else {
                            [lines removeObject:compareLine];
                        }
                    } else {
                        baseLine = compareLine;
                    }
                }
                j++;
            }
        }
    }
    
    // 绘制View
    TaggingView* taggingView = [[TaggingView alloc] initWithFrame:view.bounds lines:lines];
    [view addSubview:taggingView];
}

+ (MMLine*)verticalLineWithFrameObj1:(MMFrameObject*)frameObj1 frameObj2:(MMFrameObject*)frameObj2 {
    
    // frameObj2整体在frameObj1下面
    if (frameObj1.frame.origin.y + frameObj1.frame.size.height >= frameObj2.frame.origin.y) {
        return nil;
    }
    
    // 过滤间距太小
    if (ABS(frameObj1.frame.origin.y + frameObj1.frame.size.height - frameObj2.frame.origin.y) < 5) {
        return nil;
    }
    
    CGFloat obj1BottomY = frameObj1.frame.origin.y + frameObj1.frame.size.height;
    CGFloat obj1Width = frameObj1.frame.size.width;
    
    CGFloat obj2TopY = frameObj2.frame.origin.y;
    CGFloat obj2Width = frameObj2.frame.size.width;
    
    CGFloat handle = 0;
    CGFloat pointX = [self approperiatePointWithInternal:[[MMInterval alloc] initWithStart:frameObj1.frame.origin.x length:obj1Width] internal2:[[MMInterval alloc] initWithStart:frameObj2.frame.origin.x length:obj2Width] handle:&handle];
    
    MMLine* line = [[MMLine alloc] initWithPoint1:[[MMShortPoint alloc] initWithX:pointX y:obj1BottomY handle:handle] point2:[[MMShortPoint alloc] initWithX:pointX y:obj2TopY handle:handle]];
    
    return line;
}

+ (MMLine*)horizontalLineWithFrameObj1:(MMFrameObject*)frameObj1 frameObj2:(MMFrameObject*)frameObj2 {
    if (ABS(frameObj1.frame.origin.x - frameObj2.frame.origin.x) < 3) {
        return nil;
    }
    
    // frameObj2整体在frameObj1右边
    if (frameObj1.frame.origin.x + frameObj1.frame.size.width >= frameObj2.frame.origin.x) {
        return nil;
    }
    
    CGFloat obj1RightX = frameObj1.frame.origin.x + frameObj1.frame.size.width;
    CGFloat obj1Height = frameObj1.frame.size.height;
    
    CGFloat obj2LeftX = frameObj2.frame.origin.x;
    CGFloat obj2Height = frameObj2.frame.size.height;
    
    CGFloat handle = 0;
    CGFloat pointY = [self approperiatePointWithInternal:[[MMInterval alloc] initWithStart:frameObj1.frame.origin.y length:obj1Height] internal2:[[MMInterval alloc] initWithStart:frameObj2.frame.origin.y length:obj2Height] handle:&handle];
    
    MMLine* line = [[MMLine alloc] initWithPoint1:[[MMShortPoint alloc] initWithX:obj1RightX y:pointY handle:handle] point2:[[MMShortPoint alloc] initWithX:obj2LeftX y:pointY handle:handle]];
    
    return line;
}

+ (CGFloat)approperiatePointWithInternal:(MMInterval*)internal1 internal2:(MMInterval*)internal2 handle:(CGFloat*)handle {
    CGFloat MINHandleValue = 20;
    CGFloat pointValue = 0;
    CGFloat handleValue = 0;
    MMInterval* bigInternal;
    MMInterval* smallInternal;
    if (internal1.length > internal2.length) {
        bigInternal = internal1;
        smallInternal = internal2;
    } else {
        bigInternal = internal2;
        smallInternal = internal1;
    }
    
    // 线段分割法
    if (smallInternal.start < bigInternal.start && smallInternal.start+smallInternal.length < bigInternal.start) {
        CGFloat tmpHandleValue = bigInternal.start - smallInternal.start+smallInternal.length;
        pointValue = bigInternal.start - tmpHandleValue/2;
        handleValue = MAX(tmpHandleValue, MINHandleValue);
    }
    if (smallInternal.start < bigInternal.start && smallInternal.start+smallInternal.length >= bigInternal.start) {
        CGFloat tmpHandleValue = smallInternal.start+smallInternal.length - bigInternal.start;
        pointValue = bigInternal.start + tmpHandleValue/2;
        handleValue = MAX(tmpHandleValue, MINHandleValue);
    }
    if (smallInternal.start >= bigInternal.start && smallInternal.start+smallInternal.length <= bigInternal.start+bigInternal.length) {
        CGFloat tmpHandleValue = smallInternal.length;
        pointValue = smallInternal.start + tmpHandleValue/2;
        handleValue = MAX(tmpHandleValue, MINHandleValue);
    }
    if (smallInternal.start >= bigInternal.start && smallInternal.start+smallInternal.length > bigInternal.start+bigInternal.length) {
        CGFloat tmpHandleValue = bigInternal.start+bigInternal.length - smallInternal.start;
        pointValue = bigInternal.start + tmpHandleValue/2;
        handleValue = MAX(tmpHandleValue, MINHandleValue);
    }
    if (smallInternal.start >= bigInternal.start+bigInternal.length && smallInternal.start+smallInternal.length > bigInternal.start+bigInternal.length) {
        CGFloat tmpHandleValue = smallInternal.start - (bigInternal.start+bigInternal.length);
        pointValue = smallInternal.start - tmpHandleValue/2;
        handleValue = MAX(tmpHandleValue, MINHandleValue);
    }
    
    if (handle) {
        *handle = handleValue;
    }
    
    return pointValue;
}

+ (void)registerBorderTestViewWithView:(UIView*)view {
    CGFloat minWH = 1.0/[UIScreen mainScreen].scale;
    MMBorderAttachView* leftBorderView = [[MMBorderAttachView alloc] initWithFrame:CGRectMake(0, 0, minWH, view.bounds.size.height)];
    [view addSubview:leftBorderView];
    MMBorderAttachView* rightBorderView = [[MMBorderAttachView alloc] initWithFrame:CGRectMake(view.bounds.size.width-minWH, 0, minWH, view.bounds.size.height)];
    [view addSubview:rightBorderView];
    
    MMBorderAttachView* topBorderView = [[MMBorderAttachView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, minWH)];
    [view addSubview:topBorderView];
    MMBorderAttachView* bottomBorderView = [[MMBorderAttachView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - minWH, view.bounds.size.width, minWH)];
    [view addSubview:bottomBorderView];
}

@end
