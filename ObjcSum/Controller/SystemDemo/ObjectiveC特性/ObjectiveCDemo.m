//
//  ObjectiveCDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ObjectiveCDemo.h"
#import "ObjectiveCPointor.h"

@interface ObjectiveCDemo () {
}

@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation ObjectiveCDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dict = [NSMutableDictionary dictionary];
    [self typeEncoding];
}

#pragma mark - 类型编码
/**
 *  @encode，@编译器指令 之一，返回一个给定类型编码为一种内部表示的字符串（例如，@encode(int) → i），类似于 ANSI C 的 typeof 操作。
 苹果的 Objective-C 运行时库内部利用类型编码帮助加快消息分发。
 */
- (void)typeEncoding {
    NSLog(@"int        : %s", @encode(int));
    NSLog(@"float      : %s", @encode(float));
    NSLog(@"float *    : %s", @encode(float*));
    NSLog(@"char       : %s", @encode(char));
    NSLog(@"char *     : %s", @encode(char *));
    NSLog(@"BOOL       : %s", @encode(BOOL));
    NSLog(@"void       : %s", @encode(void));
    NSLog(@"void *     : %s", @encode(void *));
    
    NSLog(@"NSObject * : %s", @encode(NSObject *));
    NSLog(@"NSObject   : %s", @encode(NSObject));
    NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class])));
    NSLog(@"NSError ** : %s", @encode(typeof(NSError **)));
    
    int intArray[5] = {1, 2, 3, 4, 5};
    NSLog(@"int[]      : %s", @encode(typeof(intArray)));
    
    float floatArray[3] = {0.1f, 0.2f, 0.3f};
    NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
    
    typedef struct _struct {
        short a;
        long long b;
        unsigned long long c;
    } Struct;
    NSLog(@"struct     : %s", @encode(typeof(Struct)));
    
    /**
     2016-03-01 16:53:43.883 ObjcSum[33695:2516766] int        : i
     2016-03-01 16:53:43.883 ObjcSum[33695:2516766] float      : f
     2016-03-01 16:53:43.884 ObjcSum[33695:2516766] float *    : ^f
     2016-03-01 16:53:43.884 ObjcSum[33695:2516766] char       : c
     2016-03-01 16:53:43.885 ObjcSum[33695:2516766] char *     : *
     2016-03-01 16:53:43.885 ObjcSum[33695:2516766] BOOL       : B
     2016-03-01 16:53:43.885 ObjcSum[33695:2516766] void       : v
     2016-03-01 16:53:43.885 ObjcSum[33695:2516766] void *     : ^v
     2016-03-01 16:53:43.886 ObjcSum[33695:2516766] NSObject * : @
     2016-03-01 16:53:43.886 ObjcSum[33695:2516766] NSObject   : {NSObject=#}
     2016-03-01 16:53:43.886 ObjcSum[33695:2516766] [NSObject] : #
     2016-03-01 16:53:43.887 ObjcSum[33695:2516766] NSError ** : ^@
     2016-03-01 16:53:43.887 ObjcSum[33695:2516766] int[]      : [5i]
     2016-03-01 16:53:43.887 ObjcSum[33695:2516766] float[]    : [3f]
     2016-03-01 16:53:43.887 ObjcSum[33695:2516766] struct     : {_struct=sqQ}
     */
}

#pragma mark - 随机数

- (void)random {
    //0 到 N - 1 之间的随机整数
    NSInteger r = arc4random_uniform(20);
    
    /**
     *  0 到 1 之间的随机浮点数（double）
     
     如果你要生成一个随机 double 或 float，另一个很好的选择是功能较模糊的 rand48 家族，包括 drand48(3)。
     
     不像 arc4random 函数， rand48 函数在产生随机数之前需要种子的初始值。这个种子函数 srand48(3) 应该只运行一次。
     */
    srand48(time(NULL));
    double rd = drand48();
    
    /**
     *  生成一个随机的小写 NSString
     
     如果你是对一个已知的，连续范围的 Unicode 字符做处理，例如小写字母 (U+0061 — U+007A)，你可以从 char 做一个简单的换算：
     
     */
    NSString *letter = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
    
    /**
     *  从一个 NSString 选择一个随机字符
     
     另外，从一组你选择的字符中来挑选随机字母的一个简单的方法是简单地创建一个包含所有可能的字母的字符串：
     */
    NSString *vowels = @"aeiouy";
    NSString *letter2 = [vowels substringWithRange:NSMakeRange(arc4random_uniform([vowels length]), 1)];
    if (r || rd || letter || letter2) {
        
    }
}

/**
 *  随机排序一个 NSArray
 *
 *  @return randomArray
 */
- (NSArray *)randomArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSUInteger count = [mutableArray count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    return [NSArray arrayWithArray:mutableArray];
}

@end
