//
//  NSObject+Debug.m
//  MyFrame
//
//  Created by sihuan on 15/6/15.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import "NSObject+Debug.h"
#import <objc/runtime.h>

#import "Aspects.h"

@implementation NSObject (Debug)

#pragma mark - Debug 相关
- (void)registerDebugInfoForApis:(NSString*)funcStrs,... NS_REQUIRES_NIL_TERMINATION {
    
    NSString *curStr = funcStrs;
    va_list list;
    if(funcStrs)
    {
        [self registerDebugInfoForApi:NSSelectorFromString(curStr)];
        va_start(list, funcStrs);
        while ((curStr = va_arg(list, NSString*))) {
            [self registerDebugInfoForApi:NSSelectorFromString(curStr)];
        }
        va_end(list);
    }
}

- (void)registerDebugInfoForSelectors:(SEL)sels,... NS_REQUIRES_NIL_TERMINATION {
    SEL curSel = sels;
    
    va_list list;
    if (sels) {
        [self registerDebugInfoForApi:curSel];
        va_start(list, sels);
        while ((curSel = va_arg(list, SEL))) {
            [self registerDebugInfoForApi:curSel];
        }
        va_end(list);
    }
}

- (void)registerDebugInfoForAllSelectors {
    unsigned int varCount = 0;
    Method *methods = class_copyMethodList(self.class, &varCount);
    if (varCount > 0) {
        for (int i=0; i < varCount; i++) {
            Method method = methods[i];
            [self registerDebugInfoForApi:method_getName(method)];
        }
        
    }
    
    free(methods);
}

#pragma mark - Private
- (void)registerDebugInfoForApi:(SEL)func {
    if ([self respondsToSelector:func]) {
        [self aspect_hookSelector:func withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo){
            [self debugBefore];
        }  error:NULL];
        
        
        [self aspect_hookSelector:func withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self debugAfter];
        }  error:NULL];
    }
    
}

#pragma mark - 
- (void)debugBefore {
    NSLog(@"-- debugBefore --");
}

- (void)debugAfter {
    NSLog(@"-- debugAfter --");
}




@end
