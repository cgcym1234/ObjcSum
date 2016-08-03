//
//  YYLog.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYLog__
#define __MySimpleFrame__YYLog__

#include <stdio.h>

#pragma mark - 大致意思就是SlowLog记录的是系统最近N个超过一定时间的查询，就是比较耗时的查询

/* 慢日志结构体，将会插入到slowLogList,慢日志列表中 */
typedef struct YYLog {
    char **argv;
    int argc;
    
    long long tid;  //自身的id标识
    long duration;  //query操作所消耗的时间，单位为nanoseconds
    time_t time;    //查询发发生的时间
}YYLog;

#endif /* defined(__MySimpleFrame__YYLog__) */
