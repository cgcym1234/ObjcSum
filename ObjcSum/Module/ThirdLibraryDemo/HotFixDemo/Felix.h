//
//  Felix.h
//  ObjcSum
//
//  Created by yangyuan on 2018/4/4.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Aspects.h"

#import <objc/runtime.h>

#import <JavaScriptCore/JavaScriptCore.h>



@interface Felix: NSObject

+ (void)fixIt;

+ (void)evalString:(NSString *)javascriptString;

@end
