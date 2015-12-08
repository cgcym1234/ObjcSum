//
//  FoundationDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/30.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "FoundationDemo.h"
#import "UIViewController+Extension.h"

@interface FoundationDemo ()

@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;
@property (nonatomic, strong) NSString *str3;
@property (nonatomic, weak) NSMutableArray *arr1;
@property (nonatomic, weak) NSMutableArray *arr2;

@property (nonatomic, strong) NSMutableDictionary *dict;

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


@end
