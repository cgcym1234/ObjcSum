//
//  HeaderSystem.h
//  MyFrame
//
//  Created by sihuan on 15/6/4.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef MyFrame_HeaderSystem_h
#define MyFrame_HeaderSystem_h


#define SystemIsIpad                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SystemIsIphone               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SystemIsRetina               ([[UIScreen mainScreen] scale] >= 2.0)

#define SystemScreenWidth            ([[UIScreen mainScreen] bounds].size.width)
#define SystemScreenHeight           ([[UIScreen mainScreen] bounds].size.height)
#define SystemScreenMaxLength        (MAX(SystemScreenWidth, SystemScreenHeight))
#define SystemScreenMinLength        (MIN(SystemScreenWidth, SystemScreenHeight))

#define SystemIsIphone4             (SystemIsIphone && SystemScreenMaxLength < 568.0)
#define SystemIsIphone5             (SystemIsIphone && SystemScreenMaxLength == 568.0)
#define SystemIsIphone6             (SystemIsIphone && SystemScreenMaxLength == 667.0)
#define SystemIsIphone6P            (SystemIsIphone && SystemScreenMaxLength == 736.0)

#endif
