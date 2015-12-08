//
//  NSNotificationCenter+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "NSNotificationCenter+YYExtension.h"
#include <pthread.h>

@implementation NSNotificationCenter (YYExtension)

+ (void)_yy_postNotification:(NSNotification *)notification {
    [[self defaultCenter] postNotification:notification];
}

+ (void)_yy_postNotificationWithInfo:(NSDictionary *)info {
    NSString *name = [info objectForKey:@"name"];
    id object = [info objectForKey:@"object"];
    NSDictionary *userInfo = [info objectForKey:@"userInfo"];
    
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

/**
 Posts a given notification to the receiver on main thread.
 If current thread is main thread, the notification is posted synchronized;
 otherwise, is posted asynchronized.
 
 @param notification  The notification to post.
 An exception is raised if notification is nil.
 */
- (void)yy_postNotificationOnMainThread:(NSNotification *)notification {
    return[self yy_postNotificationOnMainThread:notification waitUntilDone:NO];
}

/**
 Posts a given notification to the receiver on main thread.
 
 @param notification The notification to post.
 An exception is raised if notification is nil.
 
 @param wait         A Boolean that specifies whether the current thread blocks
 until after the specified notification is posted on the
 receiver on the main thread. Specify YES to block this
 thread; otherwise, specify NO to have this method return
 immediately.
 */
- (void)yy_postNotificationOnMainThread:(NSNotification *)notification
                          waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotification:notification];
    [self performSelectorOnMainThread:@selector(_yy_postNotification:) withObject:notification waitUntilDone:wait];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronized; otherwise, is posted asynchronized.
 
 @param name    The name of the notification.
 
 @param object  The object posting the notification.
 */
- (void)yy_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object {
    return [self yy_postNotificationOnMainThreadWithName:name object:object userInfo:nil waitUntilDone:NO];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronized; otherwise, is posted asynchronized.
 
 @param name      The name of the notification.
 
 @param object    The object posting the notification.
 
 @param userInfo  Information about the the notification. May be nil.
 */
- (void)yy_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object
                                       userInfo:(NSDictionary *)userInfo {
    return [self yy_postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread.
 
 @param name     The name of the notification.
 
 @param object   The object posting the notification.
 
 @param userInfo Information about the the notification. May be nil.
 
 @param wait     A Boolean that specifies whether the current thread blocks
 until after the specified notification is posted on the
 receiver on the main thread. Specify YES to block this
 thread; otherwise, specify NO to have this method return
 immediately.
 */
- (void)yy_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object
                                       userInfo:(NSDictionary *)userInfo
                                  waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    
    NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] initWithCapacity:3];
    if (name) [info setObject:name forKey:@"name"];
    if (object) [info setObject:object forKey:@"object"];
    if (userInfo) [info setObject:userInfo forKey:@"userInfo"];
    [self performSelectorOnMainThread:@selector(_yy_postNotificationWithInfo:) withObject:info waitUntilDone:wait];
}

@end

