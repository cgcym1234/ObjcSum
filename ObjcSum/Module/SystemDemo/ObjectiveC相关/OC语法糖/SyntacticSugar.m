//
//  SyntacticSugar.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "SyntacticSugar.h"
#import "SyntacticSugar+Extention.h"

@implementation SyntacticSugar

- (void)demo {
    //NSNumber的语法糖
    NSNumber *intNumber = [NSNumber numberWithInt:100];
    NSNumber *intNumber2 = @100;
    //不可变字符串的语法糖
    NSString *string = @"hanjunqiang";
    //可变字符串的语法糖
    NSMutableString *mString = @"大爱中华".mutableCopy;//后缀不能丢
    
    //不可变数组的语法糖
    NSArray *array = @[@"1",@"2",@"3",@"4"];
    NSLog(@"%@",array);
    
    //访问数组元素的语法糖
    NSLog(@"%@",array[1]);
    
    //可变数组的语法糖
    NSMutableArray *mArray = @[@"1",@"2",@"3",@"4"].mutableCopy;
    
    //字典的语法糖
    //字典对象[key值]取出对应的value值
    NSDictionary *dict = @{@"a":@"1",@"b":@"2"};//key值在冒号前，value值在冒号后
    NSLog(@"%@",dict);
    NSLog(@"%@",dict[@"a"]);
    //可变字典可以赋值和修改值
    NSMutableDictionary *mDic = @{@"a":@"1",@"b":@"2"}.mutableCopy;
    mDic[@"a"]=@"100";
    NSLog(@"%@",mDic[@"a"]);
    
    //UI使用部分
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"12345"];
        imageView.frame = CGRectMake(0, 0, 100, 100);
        imageView;
    });
    
    SyntacticSugar.sName = @"Haha";
    NSLog(@"%@, %@", self.name, SyntacticSugar.sName);
    
    
}


- (NSString *)name {
    if (!_name) {
        _name = @"调调的";
    }
    return _name;
}

@end























