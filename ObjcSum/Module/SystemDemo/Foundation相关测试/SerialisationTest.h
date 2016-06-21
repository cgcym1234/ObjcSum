//
//  SerialisationTest.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SerialisationTest : NSObject

#pragma mark - 序列化效率测试

/**
 *  NSJSONSerialization, NSPropertyListSerialization, NSKeyedArchiver,
 NSArchiver --这个在iOS SDK中没有，mac os中提供
 */

+ (void)TestNSJSONSerialization;
+ (void)TestNSPropertyListSerialization;
+ (void)TestNSKeyedArchiver;

//iOS SDK中没有 NSArchiver
+ (void)TestNSArchiver;


#pragma mark - 测试结果
/**
 *  Sample model object:
 
 {
 UUID = "90B471CC-C740-4C1E-A421-EA996E34B505";
 point = "{1026495492, 1745139186}";
 rect = "{{1026495492, 1745139186}, {2609842131, 1633372867}
 }
 
 Results serialising / deserialising 100,000 model objects on a 2.66GHz Mac Pro (seconds):
 
 NSJSONSerialization         2.359547
 NSPropertyListSerialization 3.560538
 NSArchiver                  3.681572
 NSKeyedArchiver             9.563317
 */

@end
