//
//  HeaderGlobal.h
//  MyFrame
//
//  Created by sihuan on 15/6/4.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//


#ifndef MyFrame_HeaderGlobal_h
#define MyFrame_HeaderGlobal_h

#import "HeaderColor.h"
#import "HeaderSystem.h"
#import "HeaderStoryboard.h"
#import "HeaderNotification.h"
#import "HeaderMacroCommon.h"

//日志系统
//#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG

//设置要显示的日志的最低级别
//static const int ddLogLevel = DDLogLevelVerbose;

#else
//static const int ddLogLevel = DDLogLevelOff;

#endif

//替换NSLog为DDLogInfo
//#define NSLog(fmt, ...) DDLogInfo((@"[file %s] [func %s] [Line %d] " fmt), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define NSLog DDLogInfo
//#define NSLog(fmt, ...) DDLogInfo((@"[func %s] [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#endif
