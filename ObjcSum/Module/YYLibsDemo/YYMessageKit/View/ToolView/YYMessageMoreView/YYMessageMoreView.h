//
//  YYMessageMoreView.h
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHorizontalScrollView.h"

@class YYMessageMoreView;

@protocol YYMessageMoreViewDelegate <NSObject>

@optional
- (void)yyMessageMoreView:(YYMessageMoreView *)view didSelectImages:(NSArray *)images;

@end

@interface YYMessageMoreView : UIView

@property (nonatomic, weak) id<YYMessageMoreViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *containerController;

@end
