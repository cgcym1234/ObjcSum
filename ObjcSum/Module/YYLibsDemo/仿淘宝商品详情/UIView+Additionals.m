//
//  UIView+Additionals.m
//  JuMei
//
//  Created by Jinxiao on 8/13/14.
//  Copyright (c) 2014 Jumei Inc. All rights reserved.
//

#import "UIView+Additionals.h"

@implementation UIView (ParentChain)

- (UIViewController *) avaliableViewController
{
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
    if([nextResponder isKindOfClass:[UIViewController class]])
    {
        return nextResponder;
    }
    else if([nextResponder isKindOfClass:[UIView class]])
    {
        return [nextResponder traverseResponderChainForUIViewController];
    }
    else
    {
        return nil;
    }
}

@end


@implementation UIView (Properties)



#pragma mark - view + frame

- (void)setFrameX:(CGFloat)frameX {
	CGRect frame = self.frame;
	frame.origin.x = frameX;
    
	self.frame = frame;
}

- (void)setFrameY:(CGFloat)frameY {
	CGRect frame = self.frame;
	frame.origin.y = frameY;
    
	self.frame = frame;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
	CGRect frame = self.frame;
	frame.size.width = frameWidth;
    
	self.frame = frame;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
	CGRect frame = self.frame;
	frame.size.height = frameHeight;
    
	self.frame = frame;
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (CGFloat) frameMatch:(CGFloat) source
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return source * (screenHeight / 480.0f);
}

- (CGRect) fixFrame:(CGRect)frame standardWidth:(CGFloat) width
{
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / width;
    return CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);
}

@end
