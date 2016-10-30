//
//  YYPageViewController.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPageViewController;

@protocol YYPageViewControllerDelegate <NSObject>

@required
- (NSInteger)numberOfControllersInYYPageViewController:(YYPageViewController *)pageViewController;

- (UIViewController *)yyPageViewController:(YYPageViewController *)pageViewController controllerAtPage:(NSInteger)index;

@optional
- (void)yyPageViewController:(YYPageViewController *)pageViewController didScrollToPage:(NSInteger)page prevPage:(NSInteger)prevPage;

@end

@interface YYPageViewController : UIViewController

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;
//总页数
@property (nonatomic, assign) NSInteger totalPages;
//当前显示页
@property (nonatomic, assign) NSInteger currentPage;
//前一次的页面，默认0
@property (nonatomic, assign) NSInteger prevPage;

@property (nonatomic, weak) id<YYPageViewControllerDelegate> delegate;

- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end
