//
//  YYLogger.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 公开的便捷调用

/**< 指定要显示日志的最小级别，默认输出 >= Info级别日志 */
#define yyLogSetDefaultMiniLevel(level) YYLogger.defaultInstance.miniLevel = level

#define yyLog(level, fmt, ...) [YYLogger.defaultInstance log:level file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yyLogDebug(fmt, ...) [YYLogger.defaultInstance log:YYLogLevelDebug file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yyLogInfo(fmt, ...) [YYLogger.defaultInstance log:YYLogLevelInfo file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yyLogWarning(fmt, ...) [YYLogger.defaultInstance log:YYLogLevelWarning file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yyLogError(fmt, ...) [YYLogger.defaultInstance log:YYLogLevelError file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yyLogFatal(fmt, ...) [YYLogger.defaultInstance log:YYLogLevelFatal file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]




/**< 日志级别
 DEBUG < INFO < WARN < ERROR < FATAL，分别用来指定这条日志信息的重要程度，
 规则：只输出级别不低于设定级别的日志信息，假设Loggers级别设定为INFO，
 则INFO、WARN、ERROR和FATAL级别的日志信息都会输出，而级别比INFO低的DEBUG则不会输出。
 */
typedef NS_ENUM(NSUInteger, YYLogLevel) {
    YYLogLevelDebug = 0,/// 调试
    YYLogLevelInfo,     /// 信息
    YYLogLevelWarning,  /// 警告
    YYLogLevelError,    /// 一般错误
    YYLogLevelFatal     /// 致命错误
};

@interface YYLogger : NSObject

//规则：只输出级别不低于设定级别的日志信息, 默认输出 >= Info级别日志
@property (nonatomic, assign) YYLogLevel miniLevel;

+ (instancetype)defaultInstance;

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
     format:(NSString *)format, ...;

@end








