//
//  UncaughtExceptionHandler.h
//  MeileleForiPad
//
//  Created by chester on 7/21/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  崩溃日志获取对象
 */
@interface UncaughtExceptionHandler : NSObject
@end

/**
 *  初始化异常处理模块
 */
void InstallExceptionHandler(void);