//
//  YYPageController.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/28.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPageController;

@protocol YYPageControllerDelegate <NSObject>

@required
- (NSInteger)yyPageControllerNumberOfControllers;

- (UIViewController *)yyPageController:(YYPageController *)pageController controllerAtIndex:(NSInteger)index;

@optional
- (void)yyPageController:(YYPageController *)pageController didScrollToPage:(NSInteger)page;

@end

@interface YYPageController : UIViewController

//总页数
@property (nonatomic, assign) NSInteger totalPages;
//当前显示页
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, weak) id<YYPageControllerDelegate> delegate;

@end
