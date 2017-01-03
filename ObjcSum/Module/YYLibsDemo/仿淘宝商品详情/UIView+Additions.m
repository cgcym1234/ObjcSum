//
//  UIView+Additions.m
//  MallLVC
//
//  Created by jianning on 14-6-5.
//  Copyright (c) 2014年 jumei.com. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

UIInterfaceOrientation TTDeviceOrientation() {
	UIInterfaceOrientation orient = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
	if (!orient) {
		return UIInterfaceOrientationPortrait;
	} else {
		return orient;
	}
}


+ (UIView *)topView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (window.subviews.count > 0) {
        return [window.subviews objectAtIndex:0];
    } else {
        return window;
    }
}

- (CGPoint)originInTopView {
    CGPoint origin = self.frame.origin;
    CGPoint superOrigin = self.superview.frame.origin;
    if ([self.superview isKindOfClass:[UIScrollView class]] ) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        origin = CGPointMake(origin.x - scrollView.contentOffset.x,
                             origin.y - scrollView.contentOffset.y);
    }
    if (self.superview == [UIView topView]) {
        return superOrigin;
    } else {
        superOrigin = [self.superview originInTopView];
        return CGPointMake(origin.x + superOrigin.x, origin.y + superOrigin.y);
    }
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

- (void)removeSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (CGPoint)centerOfFrame {
	CGRect rect = self.frame;
	return CGPointMake(rect.origin.x + rect.size.width / 2.0f,
					   rect.origin.y + rect.size.height / 2.0f);
}

- (CGPoint)centerOfBounds {
	CGRect rect = self.bounds;
	return CGPointMake(rect.origin.x + rect.size.width / 2.0f,
					   rect.origin.y + rect.size.height / 2.0f);
}

- (UIView*)subViewWithTag:(int)tag {
	for (UIView *v in self.subviews) {
		if (v.tag == tag) {
			return v;
		}
	}
	return nil;
}

+ (UIView *)keyView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (window.subviews.count > 0) {
        return [window.subviews objectAtIndex:0];
    } else {
        return window;
    }
}


- (void)setRoundedCorners:(UIViewRoundedCornerMask)corners radius:(CGFloat)radius {
	CGRect rect = self.bounds;
    
	CGFloat minx = CGRectGetMinX(rect);
	CGFloat midx = CGRectGetMidX(rect);
	CGFloat maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect);
	CGFloat midy = CGRectGetMidY(rect);
	CGFloat maxy = CGRectGetMaxY(rect);
    
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, minx, midy);
	CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, (corners & UIViewRoundedCornerUpperLeft) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, (corners & UIViewRoundedCornerUpperRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, (corners & UIViewRoundedCornerLowerRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, (corners & UIViewRoundedCornerLowerLeft) ? radius : 0);
	CGPathCloseSubpath(path);
    
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	[maskLayer setPath:path];
	[[self layer] setMask:nil];
	[[self layer] setMask:maskLayer];

	CFRelease(path);
}


- (UIImage *)snapshotWithBound:(CGRect)bounds
{
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
    [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
