//
//  InterviewDemo.h
//  ObjcSum
//
//  Created by sihuan on 15/11/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 1. 风格纠错题

//1. enum 建议使用 NS_ENUM 和 NS_OPTIONS 宏来定义枚举类型
typedef NS_ENUM(NSUInteger, YYSex) {
    YYSexUnknown,
    YYSexMan,
    YYSexWoman,
};

/**
 *  2.age 属性的类型：应避免使用基本类型，建议使用 Foundation 数据类型，对应关系如下：
 int -> NSInteger
 unsigned -> NSUInteger
 float -> CGFloat
 动画时间 -> NSTimeInterval
 */

//3.如果工程项目非常庞大，需要拆分成不同的模块，可以在类、typedef宏命名的时候使用前缀。
@interface YYUser : NSObject<NSCopying>

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSInteger age;
@property (nonatomic, readonly, assign) YYSex sex;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age sex:(YYSex)sex;
+ (instancetype)userWithName:(NSString *)name age:(NSUInteger)age sex:(YYSex)sex;

- (void)addFriend:(YYUser *)user;
- (void)removeFriend:(YYUser *)user;

@end

/**
 4.doLogIn方法不应写在该类中：
 无论是 MVC 模式还是 MVVM 模式，业务逻辑都不应当写在 Model 里：MVC 应在 C，MVVM 应在 VM。
 
 5.doLogIn 方法命名不规范：添加了多余的动词前缀。 请牢记：
 如果方法表示让对象执行一个动作，使用动词打头来命名，注意不要使用 do，does 这种多余的关键字，动词本身的暗示就足够了。
 应为 -logIn （注意： Login 是名词， LogIn 是动词，都表示登陆。）
 
 6. -(id)initUserModelWithUserName: (NSString*)name withAge:(int)age;方法中不要用 with 来连接两个参数: withAge: 应当换为age:，age: 已经足以清晰说明参数的作用，也不建议用 andAge: ：通常情况下，即使有类似 withA:withB: 的命名需求，也通常是使用withA:andB: 这种命名，用来表示方法执行了两个相对独立的操作（从设计上来说，这时候也可以拆分成两个独立的方法），它不应该用作阐明有多个参数
 
 7. 由于字符串值可能会改变，所以要把相关属性的“内存管理语义”声明为 copy 。
 
 8. 按照接口设计的惯例，如果设计了“初始化方法” (initializer)，也应当搭配一个快捷构造方法。而快捷构造方法的返回值，建议为 instancetype，为保持一致性，init 方法和快捷构造方法的返回类型最好都用 instancetype。
 
 9. 如果基于第一种修改方法：既然该类中已经有一个“初始化方法” (initializer)，用于设置“姓名”(Name)、“年龄”(Age)和“性别”(Sex）的初始值: 那么在设计对应 @property 时就应该尽量使用不可变的对象：其三个属性都应该设为“只读”。用初始化方法设置好属性值之后，就不能再改变了。
 
 initUserModelWithUserName 如果改为 initWithName 会更加简洁，而且足够清晰。
 UserModel 如果改为 User 会更加简洁，而且足够清晰。
 UserSex如果改为Sex 会更加简洁，而且足够清晰。
 */

@interface InterviewDemo : UIViewController

@end
