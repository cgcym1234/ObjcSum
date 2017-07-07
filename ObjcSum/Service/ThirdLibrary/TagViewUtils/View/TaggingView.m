//
//  TaggingView.m
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "TaggingView.h"
#import "MMTagModel.h"

@interface TaggingView ()
@property (nonatomic, strong) NSArray<MMLine*>* lines;;
@end

@implementation TaggingView

- (instancetype)initWithFrame:(CGRect)frame lines:(NSArray<MMLine*>*)lines {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.05];
        _lines = lines;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (MMLine* line in _lines) {
        // 绘制线段
        CGContextSetLineWidth(context, 2.0f/[UIScreen mainScreen].scale);  //线宽
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetRGBStrokeColor(context, 255.0 / 255.0, 0.0 / 255.0, 70.0 / 255.0, 1.0);  //线的颜色
        CGContextBeginPath(context);
        //设置起始点
        CGContextMoveToPoint(context, line.point1.point.x, line.point1.point.y);
        //增加点
        CGContextAddLineToPoint(context, line.point2.point.x, line.point2.point.y);
        CGContextStrokePath(context);
        
        // 绘制文字
        NSString *string = [NSString stringWithFormat:@"%.0f px", line.lineWidth];
        UIFont *fount = [UIFont systemFontOfSize:7];
        CGPoint centerPoint = line.centerPoint;
        NSDictionary* attrDict = @{NSFontAttributeName : fount,
                               NSForegroundColorAttributeName: [UIColor redColor],
                               NSBackgroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:0 alpha:0.5f]};
        [string drawInRect:CGRectMake(centerPoint.x - 15, centerPoint.y - 6, 30, 16) withAttributes:attrDict];
    }
}

@end
