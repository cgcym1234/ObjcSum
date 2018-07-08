//
//  GenericClass.m
//  ObjcSum
//
//  Created by yangyuan on 2018/6/27.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "GenericClass.h"

@implementation GenericClass

///类型参数是ObjectType，可以看到在类声明中是ObjectType，在类实现中是id。其实ObjectType只是一个placeholder，可以随便命名，只有在类声明，分类，类扩展中可用
- (void)add:(id)obj {
	
}

- (id)removeLast {
	return nil;
}

+ (void)test {
	GenericClass<UIView *> *test = [GenericClass new];
	//[test add:<#(UIView *)#>]
								   
}

@end
