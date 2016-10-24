//
//  YYGCDGroup.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface YYGCDGroup : NSObject

@property (nonatomic, strong, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化以及释放
- (instancetype)init;

#pragma 用法
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(NSTimeInterval)sec;

/* demo
 
 YYGCDGroup *group = [YYGCDGroup new];
 
 [[YYGCDQueue globalQueue] execute:^{
 // 代码
 } inGroup:group];
 
 [[YYGCDQueue globalQueue] execute:^{
 // 代码
 } inGroup:group];
 
 [[YYGCDQueue globalQueue] notify:^{
 // 监听group中的其他的任务完成后才会执行到此处
 
 -dispatch_group_notify-
 
 This function schedules a notification block to be submitted to the specified queue when all blocks associated with the dispatch group have completed. If the group is empty (no block objects are associated with the dispatch group), the notification block object is submitted immediately.
 
 这个方法安排了一个通知用的block到这个指定的queue当中,而当所有与这个group相关联的block都执行完毕了,才会执行这个通知的block.如果这个组空了,那这个通知用的block就会被立即的执行.
 
 } inGroup:group];
 
 
 GCDGroup *group = [GCDGroup new];
 
 [group enter];
 [[GCDQueue globalQueue] execute:^{
 
 [group leave];
 }];
 
 [group enter];
 [[GCDQueue globalQueue] execute:^{
 
 [group leave];
 }];
 
 [[GCDQueue globalQueue] execute:^{
 [group wait:3 * NSEC_PER_SEC];
 
 // 如果超时了3秒,上面的线程还没执行完,就跳过了
 }];
 */

/*
 YYGCDGroup *group = [YYGCDGroup new];
 
 [group enter];
 [[YYGCDQueue globalQueue] execute:^{
 // 代码
 [group leave];
 }];
 
 [group enter];
 [[YYGCDQueue globalQueue] execute:^{
 // 代码
 [group leave];
 }];
 
 [[YYGCDQueue globalQueue] execute:^{
 [group wait:3];
 // 如果超时了3秒,上面的线程还没执行完,就跳过了
 }];
 
 请注意,enter与leave必须成对出现!
 
 -dispatch_group_enter-
 
 Explicitly indicates that a block has entered the group.
 
 精确指定一个block进入了group.
 Calling this function increments the current count of outstanding tasks in the group. Using this function (with dispatch_group_leave) allows your application to properly manage the task reference count if it explicitly adds and removes tasks from the group by a means other than using the dispatch_group_async function. A call to this function must be balanced with a call to dispatch_group_leave. You can use this function to associate a block with more than one group at the same time.
 
 调用这个方法,将会增加当前在组中未解决的任务的数量.使用这个方法是为了能够管理任务的细节,指定什么时候结束这个任务,你也可以使用dispatch_group_async这个方法.调用了这个方法就必须使用dispatch_group_leave来平衡.你可以同时的给一个block关联上不同的group.
 
 dispatch_group_enter 与 dispatch_group_leave 能够处理更加复杂的任务类型,推荐!
 */
@end
