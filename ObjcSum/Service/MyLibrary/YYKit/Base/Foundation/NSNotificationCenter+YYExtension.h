//
//  NSNotificationCenter+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 在主线程上发送通知

@interface NSNotificationCenter (YYExtension)

/**
 Posts a given notification to the receiver on main thread.
 If current thread is main thread, the notification is posted synchronized;
 otherwise, is posted asynchronized.
 
 @param notification  The notification to post.
 An exception is raised if notification is nil.
 */
- (void)yy_postNotificationOnMainThread:(NSNotification *)notification;

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
                          waitUntilDone:(BOOL)wait;

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronized; otherwise, is posted asynchronized.
 
 @param name    The name of the notification.
 
 @param object  The object posting the notification.
 */
- (void)yy_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object;

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
                                       userInfo:(NSDictionary *)userInfo;

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
                                  waitUntilDone:(BOOL)wait;

@end

