//
//  MainShiDemo.h
//  ObjcSum
//
//  Created by sihuan on 16/5/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainShiDemo : UIViewController

/**
 什么情况下不会autosynthesis（自动合成）？
 
 1. 同时重写了 setter 和 getter 时
 2. 重写了只读属性的 getter 时
 3. 使用了 @dynamic 时
 4. 在 @protocol 中定义的所有属性
 5. 在 category 中定义的所有属性
 6. 重载的属性
	- 当你在子类中重载了父类中的属性，你必须 使用 @synthesize 来手动合成ivar。
 */


@end
