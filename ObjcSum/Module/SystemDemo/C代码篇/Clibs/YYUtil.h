//
//  YYUtil.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/26.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYUtil__
#define __MySimpleFrame__YYUtil__

#include <stdio.h>

/* 内存大小转化为单位为字节大小的数值表示 */
/*"1Gi" will return 1073741824 that is(1024*1024*1024)*/
long long yyUtilMem2ll(const char *p, int *err);

/* long long类型转化为string类型 */
int yyUtilLL2string(char *s, size_t len, long long value);

/* String类型转换为long long类型 */
int yyUtilString2ll(const char *s, size_t slen, long long *value);

/* String类型转换为long类型，核心调用的方法还是string2ll()方法 */
int yyUtilString2l(const char *s, size_t slen, long *value);

/* double类型转化为String类型 */
int yyUtilD2string(char *buf, size_t len, double value);

/* 获取输入文件名的绝对路径 */
char *yyUtilGetAbsolutePath(char *filename);

/* 判断一个路径是否就是纯粹的文件名，不是相对路径或是绝对路径 */
int yyUtilPathIsBaseName(char *path);



#endif /* defined(__MySimpleFrame__YYUtil__) */
