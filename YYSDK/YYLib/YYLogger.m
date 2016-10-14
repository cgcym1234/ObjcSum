//
//  YYLogger.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYLogger.h"


@interface YYLogger ()

/**< 日志在非主线程的一个串行队列中执行 */
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation YYLogger

+ (instancetype)defaultInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _serialQueue = dispatch_queue_create("YYLogger", DISPATCH_QUEUE_SERIAL);
        _miniLevel = YYLogLevelInfo;
    }
    return self;
}

- (NSString *)stringValueOfLevle:(YYLogLevel)level {
    switch (level) {
        case YYLogLevelDebug:
            return @"😀[DEBUG]";
            break;
        case YYLogLevelInfo:
            return @"🤔[INFO]";
            break;
        case YYLogLevelWarning:
            return @"😅[WARN]";
            break;
        case YYLogLevelError:
            return @"😱[ERROR]";
            break;
        case YYLogLevelFatal:
            return @"😭[FATAL]";
            break;
    }
}

/**
 * Logging.
 *
 *  @param level        the log level
 *  @param file         the current file
 *  @param function     the current function
 *  @param line         the current code line
 *  @param format       the log format
 */
- (void)log:(YYLogLevel)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... {
    if (level < _miniLevel) {
        return;
    }
    
    NSString *message;
    va_list args;
    if (format) {
        va_start(args, format);
        
        message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
    }
    
    dispatch_async(_serialQueue, ^{
        NSString *fileName = [[NSString stringWithFormat:@"%s", file] componentsSeparatedByString:@"/"].lastObject;
        NSString *detail = [NSString stringWithFormat:@"%@: %s: %lu", fileName, function, line];
        
        /**< 分别为level，时间，文件，方法，行号，内容。 */
        
        
        //NSLog(@"%@[%@][%@] %@", [self stringValueOfLevle:level], [NSDate date], detail, message);
        
        /*
         使用NSLog的话会输出如下信息，前面有一个时间戳
         2016-10-14 11:09:15.991 ObjcSum[45129:1373229] xxxx
         改为使用 fprintf(stderr) 即可
         */
        fprintf(stderr, "%s[%s][%s] %s\n", [self stringValueOfLevle:level].UTF8String, [NSString stringWithFormat:@"%@", [NSDate date]].UTF8String, detail.UTF8String, message.UTF8String);
    });
    
    
}



@end




















