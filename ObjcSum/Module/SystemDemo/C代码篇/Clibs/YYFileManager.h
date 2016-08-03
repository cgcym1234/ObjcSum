//
//  YYFileManager.h
//  MySumC
//
//  Created by sihuan on 15/3/31.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__YYFileManager__
#define __MySumC__YYFileManager__

#include <stdio.h>
#include "YYList.h"
#include "YYDefine.h"


typedef struct YYFileManger {
    
    char fileName[FileNameLen]; //文件名
    char *fileDir;              //文件名的绝对路径
    
    YYList *dirs;                   //当前目录下的所有目录文件
    YYList *regulars;//普通文件
    YYList *slinks;//链接文件
    
    struct YYFileManger *next;
} YYFileManger;











#endif /* defined(__MySumC__YYFileManager__) */
