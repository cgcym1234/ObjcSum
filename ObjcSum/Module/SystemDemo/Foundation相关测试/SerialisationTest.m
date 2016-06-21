//
//  SerialisationTest.m
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "SerialisationTest.h"
#import "YYBenchmark.h"

@interface Model : NSObject <NSCoding>

@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint point;
@property (nonatomic, copy) NSString *UUID;

+ (id)model;
- (NSDictionary *)dict;
+ (id)modelWithDictionary:(NSDictionary *)dictionary;

@end

static NSString * const UUIDKey = @"UUID";
static NSString * const PointKey = @"point";
static NSString * const RectKey = @"rect";

@implementation Model

+ (id)model {
    Model *model = [Model new];
    model.UUID = [[NSUUID UUID] UUIDString];
    model.point = CGPointMake(arc4random(), arc4random());
    model.rect = CGRectMake(model.point.x, model.point.y, arc4random(), arc4random());
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if ([aCoder allowsKeyedCoding]) {
        [aCoder encodeObject:self.UUID forKey:UUIDKey];
        [aCoder encodeCGPoint:self.point forKey:PointKey];
        [aCoder encodeCGRect:self.rect forKey:RectKey];
    } else {
        [aCoder encodeObject:self.UUID];
//        [aCoder encodeCGPoint:self.point];
//        [aCoder encodeCGRect:self.rect];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        if ([decoder allowsKeyedCoding]) {
            self.UUID = [decoder decodeObjectForKey:UUIDKey];
            self.point = [decoder decodeCGPointForKey:PointKey];
            self.rect = [decoder decodeCGRectForKey:RectKey];
        } else {
            self.UUID = [decoder decodeObject];
//            self.point = [decoder decodePoint];
//            self.rect = [decoder decodeRect];
        }
    }
    return self;
}

- (NSDictionary *)dict {
    return @{
             UUIDKey: self.UUID,
             PointKey: NSStringFromCGPoint(self.point),
             RectKey: NSStringFromCGRect(self.rect)
             };
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary {
    Model *model = [Model new];
    model.UUID = [dictionary objectForKey:UUIDKey];
    model.point = CGPointFromString([dictionary objectForKey:PointKey]);
    model.rect = CGRectFromString([dictionary objectForKey:RectKey]);
    return model;
}

@end;

#define ITERATIONS 100000
static NSArray *_models;

@interface SerialisationTest ()

@end

@implementation SerialisationTest

+ (void)initialize {
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:ITERATIONS];
    for (NSInteger i=0; i<ITERATIONS; i++) {
        [models addObject:[Model model]];
    }
    _models = models;
}

#pragma mark - 测试方式
/**
 1：先将数据序列化到数组里
 2：将上面数组的数据反序列化到另外一个数组里
 */

+ (void)TestNSJSONSerialization {
    NSTimeInterval cost = [YYBenchmark start:^{
        
        //1： 先将数据序列化到数组里
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (Model *model in _models) {
            [array addObject:[NSJSONSerialization dataWithJSONObject:[model dict] options:0 error:nil]];
        }
        
        //2：将上面数组的数据反序列化到另外一个数组里
        NSMutableArray *models1 = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (NSData *data in array) {
            [models1 addObject:[Model modelWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]]];
        }
    }];
    
    NSLog(@"NSJSONSerialization all: %li duration: %f ms", (unsigned long)ITERATIONS, cost);
}

+ (void)TestNSPropertyListSerialization {
    NSTimeInterval cost = [YYBenchmark start:^{
        
        //1： 先将数据序列化到数组里
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (Model *model in _models) {
            [array addObject:[NSPropertyListSerialization dataWithPropertyList:[model dict] format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil]];
        }
        
        //2：将上面数组的数据反序列化到另外一个数组里
        NSMutableArray *models1 = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (NSData *data in array) {
            [models1 addObject:[Model modelWithDictionary:[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:nil]]];
        }
    }];
    
    NSLog(@"NSPropertyListSerialization all: %li duration: %f ms", (unsigned long)ITERATIONS, cost);
}
+ (void)TestNSArchiver {
    
}
+ (void)TestNSKeyedArchiver {
    NSTimeInterval cost = [YYBenchmark start:^{
        //1： 先将数据序列化到数组里
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (Model *model in _models) {
            [array addObject:[NSKeyedArchiver archivedDataWithRootObject:model]];
        }
        
        //2：将上面数组的数据反序列化到另外一个数组里
        NSMutableArray *models1 = [NSMutableArray arrayWithCapacity:ITERATIONS];
        for (NSData *data in array) {
            [models1 addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        }
    }];
    
    NSLog(@"NSKeyedArchiver all: %li duration: %f ms", (unsigned long)ITERATIONS, cost);
}

@end
