//
//  NSObject+Debug.h
//  MyFrame
//
//  Created by sihuan on 15/6/15.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Debug)

#pragma mark - Debug 相关

#pragma mark 对指定方法添加拦截
/**
 *  Usage：[self registerDebugInfoForApis:@"test1",@"test2",nil];
 */
- (void)registerDebugInfoForApis:(NSString*)funames,... NS_REQUIRES_NIL_TERMINATION;

/**
 *  Usage: [self registerDebugInfoForSelectors:@selector(test1), @selector(test2), nil];
 */
- (void)registerDebugInfoForSelectors:(SEL)sels,... NS_REQUIRES_NIL_TERMINATION;


/**
 *  所有方法，不包含类方法
 */
- (void)registerDebugInfoForAllSelectors;




@end
