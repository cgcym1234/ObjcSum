//
//  InterviewDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "InterviewDemo.h"

@interface YYUser () {
    NSMutableSet *_friends;
}

@end

@implementation YYUser

- (void)setName:(NSString *)name {
    _name = [name copy];
}

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age sex:(YYSex)sex {
    if (self = [super init]) {
        _name = [name copy];
        _age = age;
        _sex = sex;
        _friends = [[NSMutableSet alloc] init];
    }
    return self;
}

+ (instancetype)userWithName:(NSString *)name age:(NSUInteger)age sex:(YYSex)sex {
    return [[YYUser alloc] initWithName:name age:age sex:sex];
}

#pragma mark - 如何让自己的类用 copy 修饰符？如何重写带 copy 关键字的 setter？
- (id)copyWithZone:(NSZone *)zone {
    YYUser *copy = [[[self class] allocWithZone:zone] initWithName:_name age:_age sex:_sex];
    
    //用 “copyWithZone:” 方法来拷贝的，这种浅拷贝方式不会逐个复制 set 中的元素。
    copy->_friends = [_friends mutableCopy];
    return copy;
}

//专供深拷贝所用的方法:
- (id)deepCopy {
    YYUser *copy = [[YYUser alloc] initWithName:_name age:_age sex:_sex];
    
    //深拷贝，逐个复制 set 中的元素。
    copy->_friends = [[NSMutableSet alloc] initWithSet:_friends copyItems:YES];
    return copy;
}

- (void)addFriend:(YYUser *)user {
    [_friends addObject:user];
}

- (void)removeFriend:(YYUser *)user {
    [_friends removeObject:user];
}

@end

@interface InterviewDemo ()

@end

@implementation InterviewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
