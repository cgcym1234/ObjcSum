//
//  FoundationDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "FoundationDemo.h"
#import "SerialisationTest.h"
#import "UIViewController+Extension.h"

@interface FoundationDemo ()

@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;
@property (nonatomic, strong) NSString *str3;
@property (nonatomic, weak) NSMutableArray *arr1;
@property (nonatomic, weak) NSMutableArray *arr2;

@property (nonatomic, strong) NSMutableDictionary *dict;


@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *section0;
@property (nonatomic, strong) NSMutableArray *section1;
@property (nonatomic, strong) NSMutableArray *section3;
@property (nonatomic, strong) NSMutableArray *section2;

@end

@implementation FoundationDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self arcDemo];
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    [self addButtonWithTitle:@"释放字典" action:^(UIButton *btn) {
        [weakSelf realeseDict];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"序列化效率测试" action:^(UIButton *btn) {
        [weakSelf serialisationTest];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    
    _section0 = [@[@"001", @"002"] mutableCopy];
    _section1 = [@[@"101", @"102"] mutableCopy];
    _section2 = [@[@"201", @"202"] mutableCopy];
    _section3 = _section0;
    _sectionArray = [@[_section0, _section1, _section3] mutableCopy];
    [self addButtonWithTitle:@"修改数组" action:^(UIButton *btn) {
        [weakSelf.section0 addObject:@"003"];
        _section3 = _section2;
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
}

- (void)arcDemo {
    NSString *str = [@"_str1" mutableCopy];
    _str1 = str;
    
    str = [@"_str2" mutableCopy];
    _str2 = str;
    
    str = [@"_str3" mutableCopy];
    _str3 = str;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[@[_str1, _str2, _str3] mutableCopy]];
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:@[_str1, _str2, _str3]];
    
    _dict = [NSMutableDictionary new];
    [_dict setValue:arr forKey:@"key"];
    _arr1 = arr;
    _arr2 = arr2;
    _dict[@"key"] = _arr1;
    _dict[@"key2"] = _arr2;
}

- (void)realeseDict {
    /**
     *  这里字典释放后,里面的2个数组也会被释放掉
     */
    _dict = nil;
}

#pragma mark - 序列化效率测试

- (void)serialisationTest {
    [SerialisationTest TestNSJSONSerialization];
    [SerialisationTest TestNSPropertyListSerialization];
    [SerialisationTest TestNSKeyedArchiver];
    [SerialisationTest TestNSArchiver];
    
    /**
     2015-12-29 13:22:37.896 ObjcSum[11248:608104] NSJSONSerialization all: 100000 duration: 3215.378374 ms
     2015-12-29 13:22:41.988 ObjcSum[11248:608104] NSPropertyListSerialization all: 100000 duration: 4091.101438 ms
     2015-12-29 13:22:50.954 ObjcSum[11248:608104] NSKeyedArchiver all: 100000 duration: 8966.014412 ms

     */
}

@end
