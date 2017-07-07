//
//  MMTagModel.m
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "MMTagModel.h"

@implementation MMTagModel

@end

@implementation MMLine
- (instancetype)initWithPoint1:(MMShortPoint*)point1 point2:(MMShortPoint*)point2 {
    self= [super init];
    if (self) {
        _point1 = point1;
        _point2 = point2;
    }
    return self;
}

- (CGPoint)centerPoint {
    return CGPointMake((_point1.point.x + _point2.point.x)/2, (_point1.point.y + _point2.point.y)/2);
}

- (CGFloat)lineWidth {
    return sqrt(pow(ABS(_point1.point.x - _point2.point.x), 2) + pow(ABS(_point1.point.y - _point2.point.y), 2));
}

@end

@implementation MMInterval
- (instancetype)initWithStart:(CGFloat)start length:(CGFloat)length {
    self= [super init];
    if (self) {
        _start = start;
        _length = length;
    }
    return self;
}
@end

@implementation MMShortPoint
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y handle:(CGFloat)handle {
    self= [super init];
    if (self) {
        _point = CGPointMake(x, y);
        _handle = handle;
    }
    return self;
}
@end


@implementation MMFrameObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _topInjectedObjs = [NSMutableArray array];
        _leftInjectedObjs = [NSMutableArray array];
    }
    return self;
}
@end


