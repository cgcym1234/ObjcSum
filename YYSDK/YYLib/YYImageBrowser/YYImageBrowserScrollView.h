//
//  YYImageBrowserScrollView.h
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYImageBrowserItemModel;
@class YYImageBrowserScrollView;

@protocol YYImageBrowserScrollViewDelegate <NSObject>

@optional
- (void)imageBrowserScrollViewSingleTap:(YYImageBrowserScrollView *)scroll;

@end


@interface YYImageBrowserScrollView : UIScrollView

@property (nonatomic, weak) id <YYImageBrowserScrollViewDelegate> imageDelegate;
@property (nonatomic, strong) UIImageView *imageView;

- (void)updateWithItem:(YYImageBrowserItemModel *)item;
@end
