//
//  ProccessHelper.m
//  BackGroundTest
//
//  Created by 邓杰豪 on 15/11/4.
//  Copyright © 2015年 邓杰豪. All rights reserved.
//

//[cpp] view plaincopyprint?
#import "ProccessHelper.h"
//#include<objc/runtime.h>
#include <sys/sysctl.h>

#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

@implementation ProccessHelper

//You can determine if your app is being run under the debugger with the following code from
static bool AmIBeingDebugged(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;

    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.

    info.kp_proc.p_flag = 0;

    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    // Call sysctl.

    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);

    // We're being debugged if the P_TRACED flag is set.

    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

//返回所有正在运行的进程的 id，name，占用cpu，运行时间
//使用函数int   sysctl(int *, u_int, void *, size_t *, void *, size_t)
+ (NSArray *)runningProcesses
{
    //指定名字参数，按照顺序第一个元素指定本请求定向到内核的哪个子系统，第二个及其后元素依次细化指定该系统的某个部分。
    //CTL_KERN，KERN_PROC,KERN_PROC_ALL 正在运行的所有进程
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL ,0};


    size_t miblen = 4;
    //值-结果参数：函数被调用时，size指向的值指定该缓冲区的大小；函数返回时，该值给出内核存放在该缓冲区中的数据量
    //如果这个缓冲不够大，函数就返回ENOMEM错误
    size_t size;
    //返回0，成功；返回-1，失败
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);

    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess)
        {
            if (process)
            {
                free(process);
                process = NULL;
            }
            return nil;
        }

        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);

    if (st == 0)
    {
        if (size % sizeof(struct kinfo_proc) == 0)
        {
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess)
            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--)
                {
//                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * proc_CPU = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_estcpu];
                    double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                    NSString * proc_useTiem = [[NSString alloc] initWithFormat:@"%f",t];
                    NSString *startTime = [[NSString alloc] initWithFormat:@"%ld", process[i].kp_proc.p_un.__p_starttime.tv_sec];
                    NSString * status = [[NSString alloc] initWithFormat:@"%d",process[i].kp_proc.p_flag];

                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:processID forKey:@"ProcessID"];
                    [dic setValue:processName forKey:@"ProcessName"];
                    [dic setValue:proc_CPU forKey:@"ProcessCPU"];
                    [dic setValue:proc_useTiem forKey:@"ProcessUseTime"];
                    [dic setValue:proc_useTiem forKey:@"ProcessUseTime"];
                    [dic setValue:startTime forKey:@"startTime"];

                    // 18432 is the currently running application
                    // 16384 is background
                    [dic setValue:status forKey:@"status"];

                    [array addObject:dic];
                }

                free(process);
                process = NULL;
                //NSLog(@"array = %@",array);

                return array;
            }
        }
    }

    return nil;
}

@end