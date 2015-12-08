//
//  NSThread+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSThread+YYExtension.h"

@implementation NSThread (YYExtension)

/**
 Add an autorelease pool to current runloop for current thread.
 
 @discussion If you create your own thread (NSThread/pthread), and you use
 runloop to manage your task, you may use this method to add an autorelease pool
 to the runloop. Its behavior is the same as the main thread's autorelease pool.
 */
+ (void)yy_addAutoreleasePoolToCurrentRunloop {
    
}

@end
