//
//  ChainSugar.m
//  ObjcSum
//
//  Created by yangyuan on 2018/4/25.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "ChainSugar.h"


@implementation ChainSugar

- (ChainSugarInt)add {
	return ^ChainSugar *(NSInteger n) {
		self.result += n;
		return self;
	};
}

- (ChainSugarInt)minus {
	return ^ChainSugar *(NSInteger n) {
		self.result += n;
		return self;
	};
}

- (ChainSugarInt)multiply {
	return ^ChainSugar *(NSInteger n) {
		self.result += n;
		return self;
	};
}

- (ChainSugarInt)divide {
	return ^ChainSugar *(NSInteger n) {
		self.result += n;
		return self;
	};
}

+ (void)test {
	ChainSugar *calc = [ChainSugar new];
	///使用函数的方式有一个小小的不便捷：当用点语法去访问类某一个 Block 属性时，该 Block 后面的参数 Xcode 并不会提示自动补全
	calc.add(4).minus(3).multiply(6).divide(3);
	
	///使用属性的方式，会自动提示
	calc.add1(1).minus1(0);
	NSLog(@"%d", (int)calc.result); // 输出 8
	

	
	
}

@end
