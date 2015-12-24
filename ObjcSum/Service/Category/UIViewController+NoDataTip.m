//
//  UIViewController+NoDataTip.m
//  MyLibs
//
//  Created by michael chen on 14/12/10.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIViewController+NoDataTip.h"
#import <objc/runtime.h>

#define TipBgColor [UIColor colorWithWhite:1 alpha:1]
#define TipLabelDefault @"暂时没有数据！"
#define TipImageDefault @"ic_common_no_record_new"
#define TipImageWidth 150
#define TipLabelInterval 0

#define NoDataTipTag -9876243

#define ColorFromRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NoDataTip ()

@end

@implementation NoDataTip

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tag = NoDataTipTag;
        self.backgroundColor = TipBgColor;
        self.tipLabelInterval = TipLabelInterval;
        [self setUpSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    self.frame = self.superview.bounds;
  
    CGSize size = [_tipLabel sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    
    _tipImage.center = self.center;
    
    _tipLabel.center = CGPointMake(_tipImage.center.x, _tipImage.center.y+_tipLabelInterval+size.height+_tipImage.frame.size.height/2);
    _tipLabel.bounds = CGRectMake(0, 0,self.frame.size.width, size.height);
    
    
    
//    _tipImage.center = CGPointMake(_tipLabel.center.x, _tipLabel.center.y-_tipLabelInterval-size.height-_tipImage.frame.size.height/2);
}

- (void)setUpSubViews
{
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.numberOfLines = 0;
    _tipLabel.textColor = ColorFromRGBHex(0x999999);
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = [UIFont systemFontOfSize:16];
    _tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_tipLabel];
    
    _tipImage = [[UIImageView alloc] init];
    _tipImage.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_tipImage];
}

- (void)update:(NSString *)content image:(UIImage *)image
{
    _tipLabel.text = content == nil ? TipLabelDefault : content;
    
    UIImage *imageTmp = image == nil ? [UIImage imageNamed:TipImageDefault] : image;
    _tipImage.image = imageTmp;
    [_tipImage sizeToFit];
    [self setNeedsLayout];
}

- (void)setTipLabelInterval:(NSInteger)tipLabelInterval {
    _tipLabelInterval = tipLabelInterval;
    [self setNeedsLayout];
}

- (void)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image
{
    UIView *view = [superView viewWithTag:NoDataTipTag];
    if (!view || ![view isKindOfClass:[NoDataTip class]]) {
        [superView addSubview:self];
        [self update:content image:image];
        return;
    }

    [self update:content image:image];
}

@end

#pragma mark - UIViewController (NoDataTip)
static char NoDataTipKey;
@implementation UIViewController (NoDataTip)

- (NoDataTip *)noDataTipShow
{
    
    UIView *fatherView = self.view;
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UITableView class]]) {
//            for (UIView *vv in view.subviews) {
//                if ([vv isKindOfClass:[SVPullToRefreshView class]]) {
//                    fatherView = view;
//                }
//            }
//        }
//    }
    
    return [self noDataTipShow:fatherView content:TipLabelDefault image:[UIImage imageNamed:TipImageDefault]];
}

- (NoDataTip *)noDataTipShow:(NSString *)content {
    return [self noDataTipShow:self.view content:content image:[UIImage imageNamed:TipImageDefault]];
}

- (NoDataTip *)noDataTipShow:(NSString *)content image:(UIImage *)image
{
    return [self noDataTipShow:self.view content:content image:image];
}

- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image
{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc] init];
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    [view update:content image:image];
    return view;
}
- (void)noDataTipDismiss
{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        return;
    }
    [view removeFromSuperview];
    
    objc_setAssociatedObject(self, &NoDataTipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
