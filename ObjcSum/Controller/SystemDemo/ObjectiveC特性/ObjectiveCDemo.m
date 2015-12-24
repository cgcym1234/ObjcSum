//
//  ObjectiveCDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ObjectiveCDemo.h"

@interface ObjectiveCDemo ()

@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation ObjectiveCDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dict = [NSMutableDictionary dictionary];
    [self bridgeTest];
}

#pragma mark - Object-C 指针 和 C 指针的相互转换

/**
 *  __bridge、__bridge_retained与__bridge_transfer
 */
- (void)bridgeTest {
    id obj = [NSObject new];
    
    #pragma mark Object-C 转换 C
    /**
     编译器不允许你隐式的将Object-C 指针转换成C指针
     *  Implicit conversion of Objective-C pointer type 'id' to C pointer type 'void *' requires a bridged cast
     */
//    void *p = obj;
    
    /**
     *  可以用__bridge 关键字来解决这一问题,如下2种
     CFBridgingRetain其实就是__birdge_retained
     __bridge:只做转换,对原来的oc对象无影响
     __birdge_retained:将oc对象引用计数+1
     */
    void *p1 = (__bridge void *)(obj);
    void *p2 = (void *)CFBridgingRetain(obj);
    void *p3 = (__bridge_retained void *)obj;
    
    if (p1 || p2 || p3) {
        CFBridgingRelease(p2);
    }
    
    #pragma mark C 转换 Object-C
    /**
     Implicit conversion of C pointer type 'void *' to Objective-C pointer type 'id' requires a bridged cast
     */
    //id obj4 = p1;
    /**
     *  使用__bridge或__bridge_transfer显示转换
     __bridge:只做转换,对原来的C指针无影响
     __bridge_transfer:将c指针内存的管理权交给oc对象

     */
    id obj2 = (__bridge id)(p1);
    id obj3 = (__bridge_transfer id)(p1);
    
    if (obj2 || obj3) {
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    void *s = "faadsas";
    /**
     *  这样能编译过,但是s本质还是c类型,运行时候会crash
     */
    dict[@"tt"] = (__bridge_transfer id)s;
    
    #pragma mark CFStringRef 转换 NSString
    
    CFStringRef cfStr = CFSTR("d");
    dict[@"tt"] = (__bridge_transfer NSString *)cfStr;
    
}

#pragma mark - CFStringRef 转换成 C string

char * MYCFStringCopyUTF8String(CFStringRef aString) {
    if (aString == NULL) {
        return NULL;
    }
    
    CFIndex length = CFStringGetLength(aString);
    CFIndex maxSize =
    CFStringGetMaximumSizeForEncoding(length,
                                      kCFStringEncodingUTF8);
    char *buffer = (char *)malloc(maxSize);
    if (CFStringGetCString(aString, buffer, maxSize,
                           kCFStringEncodingUTF8)) {
        return buffer;
    }
    return NULL;
}

@end
