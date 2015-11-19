//
//  HeaderMacroCommon.h
//  YYPasswordManager
//
//  Created by sihuan on 15/7/3.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef YYPasswordManager_HeaderMacroCommon_h
#define YYPasswordManager_HeaderMacroCommon_h

#define MacroDateFormatDefault @"yyyy-mm-dd hh:MM:ss"

#define MacroAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define MacroLocalizedString(key) NSLocalizedString((key), nil)

#define MacroWeakSelf(weakSelf)  __weak typeof(self)weakSelf = self

#endif
