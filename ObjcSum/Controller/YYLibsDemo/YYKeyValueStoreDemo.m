//
//  YYKeyValueStoreDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/20.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYKeyValueStoreDemo.h"

@implementation YYKeyValueStoreDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self jsonTest];
}

- (void)jsonTest {
//    NSString *object = @"test";
    NSArray *object = @[@"test", @(1)];
    
    /*object如果不是 NSArray 或 NSDictionary,会crash掉*/
    NSError *error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        NSLog(@"ERROR, faild to get json data %@", object);
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString %@", jsonString);
    
    id result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                options:(NSJSONReadingAllowFragments) error:&error];
    if (error) {
        NSLog(@"ERROR, faild to prase to json %@", jsonString);
    }
    NSLog(@"result %@", result);
}

@end
