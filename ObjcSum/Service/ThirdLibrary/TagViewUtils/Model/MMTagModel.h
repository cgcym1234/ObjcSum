//
//  MMTagModel.h
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMTagModel : NSObject

@end

@class MMShortPoint;
@interface MMLine : NSObject
@property (nonatomic, strong) MMShortPoint* point1;
@property (nonatomic, strong) MMShortPoint* point2;
- (instancetype)initWithPoint1:(MMShortPoint*)point1 point2:(MMShortPoint*)point2;
- (CGPoint)centerPoint;
- (CGFloat)lineWidth;
@end


@interface MMInterval : NSObject
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat length;
- (instancetype)initWithStart:(CGFloat)start length:(CGFloat)length;
@end



@interface MMShortPoint : NSObject
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat handle;
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y handle:(CGFloat)handle;
@end



@interface MMFrameObject : NSObject
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIView* attachedView;
@property (nonatomic, strong) NSMutableArray<MMLine*>* topInjectedObjs;
@property (nonatomic, strong) NSMutableArray<MMLine*>* leftInjectedObjs;
@end


