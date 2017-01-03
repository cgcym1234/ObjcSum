//
//  ArchitectureDemo.h
//  ObjcSum
//
//  Created by yangyuan on 2016/11/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchitectureDemo : UIViewController

@end


/*
 Class Extension 和 Category 是我们经常使用的 Objective-C 语法：
 
 // Class Extension
 @interface Sark ()
 @end
 
 // Category
 @interface Sark (Gay)
 @end
 */

/*
 
 在类组织结构上，Category 可以用来帮助拆分功能，让一个大型的类分治管理：（类似 NSString.h）
 
 // Sark.h
 @interface Sark : NSObject
 @property (nonatomic, copy) NSSting *name;
 @end
 
 @interface Sark (Gay)
 - (void)behaviorLikeGay;
 @end
 
 // Sark+Work.h <----- 也可拆分成多个文件
 @interface Sark (Work)
 - (void)writeObjectiveC;
 @end
 
 不过有两个设计原则必须要遵守：
 
 1. Category 的实现可以依赖主类，但主类一定不依赖 Category，也就是说移除任何一个 Category 的代码不会对主类产生任何影响。
 2. Category 可以直接使用主类已有的私有成员变量，但不应该为实现 Category 而往主类中添加成员变量，考虑在 Category 的实现中使用 objc association 来达到相同效果。
 
 所以 Category 一定是简单插拔的，就像买个外接键盘来扩展在 MacBook 上的写码能力，但当拔了键盘，MacBook 的运行不会受到任何影响。
 
 */


/*
 而 Class Extension 和 Category 在语言机制上有着很大差别：
 
 - Class Extension 在编译期就会将定义的 Ivar、属性、方法等直接合入主类，
 - 而 Category 在程序启动 Runtime Loading 时才会将属性（没 Ivar）和方法合入主类。
 - 但有意思的是，两者在在语法解析层面却只有细微的差别，可以尝试用 clang 命令查看一个文件的 AST（抽象语法树）
 
 
 生成 AST 是 Clang 其中一个比较重要的职责，像 Xcode 的代码补全、语法检查、代码风格规范都是在这一层做的；如果像我一样无聊，也可以玩玩 libclang，一个 C 语言 Clang API，输入代码，就能将其解析成语法树，通过遍历 AST，可以取得每个 Decl 和 Token 的信息和所处的源码行数和位置，大到类定义，小到一个逗号一个分号都能完全掌控，非常有助于理解编译器如何处理源码；有了 libclang，定义些规则就能实现个简单的 Linter 啦。
 
 上面的命令会在控制台中打印出一堆花花绿绿的语法树结构，挑出我们关注的信息：
 
 // ...
 |-ObjCCategoryDecl <line:7:1, line:9:2> line:7:12
 | |-ObjCInterface 'Sark'
 |-ObjCCategoryDecl <line:15:1, line:17:2> line:15:12 Gay
 | |-ObjCInterface 'Sark'
 // ...
 
 可以看出，Class Extension 和 Category 在 AST 中的表示都是 ObjCCategoryDecl，只是有无名字的区别，也可以说 Class Extension 是匿名的 Category。
 
 */

/*
 既然 Category 可以有 N 个，Class Extension 也可以有，且它不限于写在 .m 中，只要在 @implementation 前定义就可以，我们可以利用这个性质，将 Header 中的声明按功能归类：
 
 // Sark.h
 @interface Sark : NSObject
 // 这里定义了很多基本属性和方法
 @end
 
 @interface Sark () // Gay
 @property (nonatomic, copy) NSString *gayFriend; // 属性 √
 - (void)behaviorLikeGay;
 @end
 
 @interface Sark () // Work
 @property (nonatomic, copy) NSString *company; // 属性 √
 - (void)writeObjectiveC;
 @end
 
 与 Category 不同，Class Extension 的分组形式并没有破坏 “一个主类” 的 基本外交原则 基本结构，还可以把属性（ Ivar ）也放心丢进来。
 */


/*
 除此之外，Class Extension 还能巧妙的解决一个接口暴露问题，若有下面的声明：
 
 // Sark.framework/Sark.h
 @interface Sark : NSObject
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, copy) NSString *creditCardPassword; // secret!
 @end
 
 
 // Sark.framework/PrivateSarkWife.h
 @interface PrivateSarkWife : NSObject
 - (void)robAllMoneyFromCreditCardOfSark:(Sark *)sark; // needs password!
 @end
 
 假设 Sark.h 是 Sark.framework 唯一暴露的 Header，而 framework 中的一个私有类需要获取这个公共类的某个属性（或方法）该怎么办？上面的 creditCardPassword 属性需要一个对外不可见而对内可见的地方声明，这时候可以利用 Class Extension：
 
 // Sark.h
 @interface Sark : NSObject
 @property (nonatomic, copy) NSString *name;
 @end
 
 // Sark+Internal.h <--- new
 @interface Sark ()
 @property (nonatomic, copy) NSString *creditCardPassword;
 @end
 
 // Sark.m
 #import "Sark.h"
 #import "Sark+Internal.h" // <--- new
 
 
 将对公业务和对私业务用 Class Extension 的形式拆到两个 Header 中，这样私有类对私有属性的依赖就被成功隔离开了：
 
 // PrivateSarkWife.m
 #import "PrivateSarkWife.h"
 #import "Sark+Internal.h" // <--- 私有依赖
 
 @implementation PrivateSarkWife
 - (void)robAllMoneyFromCreditCardOfSark:(Sark *)sark {
 NSString *password = sark.creditCardPassword; // oh yeah!
 }
 @end
 */
