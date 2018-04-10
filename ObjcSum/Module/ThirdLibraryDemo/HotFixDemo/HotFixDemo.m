//
//  HotFixDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2018/4/4.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "HotFixDemo.h"
#import "Felix.h"

@interface HotFixDemo ()

@end

@implementation HotFixDemo

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self hotfixt];
	[self crashTest:0];
}

- (void)hotfixt {
	[Felix fixIt];
	
	NSString *fixScriptString = @" \
	fixInstanceMethodReplace('HotFixDemo', 'crashTest:', function(instance, originInvocation, originArguments){ \
		if (originArguments[0] == 0) { \
			console.log('zero goes here'); \
		} else { \
			runInvocation(originInvocation); \
		} \
	}); \
	\
	";

	[Felix evalString:fixScriptString];
}


- (double)crashTest:(NSInteger)num {
	if (num == 0) {
		NSArray *arr;
		NSLog(@"crash");
		exit(0);
		return [arr[1] doubleValue];
	}
	return 1.0 / num;
}


@end
