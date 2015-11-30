//
//  YYKitMacro.h
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>
#import <pthread.h>

#ifndef YYKitMacro_h
#define YYKitMacro_h

#pragma mark - C相关

#ifdef __cplusplus

#define YY_Extern_C_Begin extern "C" {
#define YY_Extern_C_End }

#else

#define YY_Extern_C_Begin
#define YY_Extern_C_End

#endif

YY_Extern_C_Begin

/**
 return the clamped value
 x在[low,high]之间,返回x
 x < low,返回low
 x > high,返回high
 */
#ifndef YY_Clamp
#define YY_Clamp(_x_, _low_, _high_) ((_x_) > (_high_) ? (_high) : ((_x_) < (_low_) ? (_low_) : (_x_)))

#endif

/**
 *  swap two value
 */
#ifndef YY_Swap
#define YY_Swap(_a_, _b_) do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while(0)

#endif


#pragma mark - NSAssert 断言
/**
 NSAssert 应当只用于 Objective-C 环境中（即方法实现中），
 条件不满足时, 调用 -handleFailureInMethod:object:file:lineNumber:description: 方法。
 
 而 NSCAssert 应当只用于 C 环境中（即函数中）
 条件不满足时, 调用 -handleFailureInFunction:file:lineNumber:description: 方法。
 
 需注意:
 NSAssert它的定义中出现了一个self, 那么有可能在你的block中你会发现你明明没有self的strong引用，
 但是仍然出现了循环引用就看看你是否使用了NSAssert这样的小东西
 */
#define YY_AssertNil(condition, desc, ...) NSAssert(!(condition), (desc), ##__VA_ARGS__)
#define YY_CAssertNil(condition, desc, ...) NSCAssert(!(condition), (desc), ##__VA_ARGS__)

#define YY_AssertNotNil(condition, desc, ...) NSAssert((condition), (desc), ##__VA_ARGS__)
#define YY_CAssertNotNil(condition, desc, ...) NSCAssert((condition), (desc), ##__VA_ARGS__)

#define YY_AssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define YY_CAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 YY_SynthDummyClass(NSString_YYAdd)
 */
#ifndef YY_SynthDummyClass
#define YY_SynthDummyClass(_name_) \
@interface YY_SynthDummyClass_ ## _name_ : NSObject @end \
@implementation YY_SynthDummyClass_ ## _name_ @end
#endif

/**
 为分类中添加的属性快速生成setter 和getter方法,属性是objc对象
 
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YY_SynthsizeCategoryPropertyObject(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef YY_SynthsizeCategoryPropertyObject
#define YY_SynthsizeCategoryPropertyObject(_getter_, _setter_, _association_, _type_) \
- (void) _setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

/**
 *  为分类中添加的属性快速生成setter 和getter方法,属性是c类型
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YYSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */

//#ifndef YY_SynthsizeCategoryPropertyCType
//#define YY_SynthsizeCategoryPropertyCType(_getter_, _setter_, _type_) \
//- (void)_setter_ : (_type_)object { \
//    [self willChangeValueForKey:@#_getter_]; \
//    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
//    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
//    [self didChangeValueForKey:@#_getter_]; \
//} \
//- (type)_getter_ { \
//    _type_ cValue = { 0 }; \
//    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
//    [value getValue:&cValue]; \
//    return cValue; \
//}
//#endif

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
static inline NSRange YY_NSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
static inline CFRange YY_CFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

/**
 Profile time cost.测试耗时
 @param ^block     code to benchmark
 @param ^complete  code time cost (millisecond)
 
 Usage:
 YYBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog("time cost: %.2f ms",ms);
 });
 
 */

static inline void YY_Benchmark(void (^block)(void), void (^complete)(double ms)) {
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 Get compile timestamp.获取编译的时间戳
 @return NSData
 */
static inline NSDate *YY_CompileTime() {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t YY_DispatchTimeDelay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
static inline dispatch_time_t YY_DispatchWalltimeDelay(NSTimeInterval second) {
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 */
static inline dispatch_time_t YY_DispatchWalltimeFromDate(NSDate *date) {
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

/**
 Whether in main queue/thread.
 */
static inline bool YY_IsInMainQueue() {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void YY_DispatchAsyncInMainQueue(void (^block)()) {
    dispatch_async(dispatch_get_main_queue(), block);
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void YY_DispatchSyncInMainQueue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


YY_Extern_C_End

#endif /* YYKitMacro_h */
