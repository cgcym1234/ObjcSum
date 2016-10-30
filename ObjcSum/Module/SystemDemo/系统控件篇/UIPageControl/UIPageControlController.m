//
//  UIPageControlController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIPageControlController.h"

@interface UIPageControlController ()

@end

@implementation UIPageControlController

- (void)pageControlInit
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
    pageControl.numberOfPages = 1;
    //    pageControl.enabled = NO;
    //    pageControl.currentPage = 2;
    //    pageControl.hidesForSinglePage = YES;
    [pageControl addTarget:self action:@selector(change1:) forControlEvents:UIControlEventValueChanged];
    pageControl.backgroundColor = [UIColor grayColor];
}

- (void)change1:(UIPageControl *)pageControl
{
    NSLog(@"index : %li", pageControl.currentPage);
}

@end
