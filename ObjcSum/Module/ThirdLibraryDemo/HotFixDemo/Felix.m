//
//  Felix.m
//  ObjcSum
//
//  Created by yangyuan on 2018/4/4.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "Felix.h"

@interface Felix ()

@end

@implementation Felix

+ (Felix *)sharedInstance {
	static Felix *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

+ (JSContext *)context {
	static JSContext *_context;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_context = [[JSContext alloc] init];
		[_context setExceptionHandler:^(JSContext *context, JSValue *value) {
			
			NSLog(@"Oops: %@", value);
		}];
	});
	
	return _context;
}

+ (void)_fixWithMethod:(BOOL)isClassMethod
	  aspectionOptions:(AspectOptions)option
		  instanceName:(NSString *)instanceName
		  selectorName:(NSString *)selectorName
			   fixImpl:(JSValue *)fixImpl {
	Class cls = NSClassFromString(instanceName);
	if (isClassMethod) {
		cls = object_getClass(cls);
	}
	SEL sel = NSSelectorFromString(selectorName);
	[cls aspect_hookSelector:sel withOptions:option usingBlock:^(id<AspectInfo> aspectInfo){
		[fixImpl callWithArguments:@[aspectInfo.instance, aspectInfo.originalInvocation, aspectInfo.arguments]];
	} error:nil];
}

+ (id)_runClassWithClassName:(NSString *)className
					selector:(NSString *)selector
						obj1:(id)obj1
						obj2:(id)obj2 {
	Class cls = NSClassFromString(className);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	return [cls performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}

+ (id)_runInstanceWithInstance:(id)instance
					selector:(NSString *)selector
						obj1:(id)obj1
						obj2:(id)obj2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	return [instance performSelector:NSSelectorFromString(selector) withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}

#pragma mark - Public

+ (void)evalString:(NSString *)javascriptString {
	[[self context] evaluateScript:javascriptString];
}

+ (void)fixIt {
	[self context][@"fixInstanceMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:NO aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};
	
	[self context][@"fixInstanceMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:NO aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};

	[self context][@"fixInstanceMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:NO aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};

	[self context][@"fixClassMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:YES aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};

	[self context][@"fixClassMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:YES aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};

	[self context][@"fixClassMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
		[self _fixWithMethod:YES aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
	};

	[self context][@"runClassWithNoParamter"] = ^id(NSString *className, NSString *selectorName) {
		return [self _runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
	};

	[self context][@"runClassWith1Paramter"] = ^id(NSString *className, NSString *selectorName, id obj1) {
		return [self _runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
	};
	
	[self context][@"runClassWith2Paramters"] = ^id(NSString *className, NSString *selectorName, id obj1, id obj2) {
		return [self _runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
	};
	
	[self context][@"runVoidClassWithNoParamter"] = ^(NSString *className, NSString *selectorName) {
		[self _runClassWithClassName:className selector:selectorName obj1:nil obj2:nil];
	};

	[self context][@"runVoidClassWith1Paramter"] = ^(NSString *className, NSString *selectorName, id obj1) {
		[self _runClassWithClassName:className selector:selectorName obj1:obj1 obj2:nil];
	};
	
	[self context][@"runVoidClassWith2Paramters"] = ^(NSString *className, NSString *selectorName, id obj1, id obj2) {
		[self _runClassWithClassName:className selector:selectorName obj1:obj1 obj2:obj2];
	};

	[self context][@"runInstanceWithNoParamter"] = ^id(id instance, NSString *selectorName) {
		return [self _runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
	};
	
	[self context][@"runInstanceWith1Paramter"] = ^id(id instance, NSString *selectorName, id obj1) {
		return [self _runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
	};
	
	[self context][@"runInstanceWith2Paramters"] = ^id(id instance, NSString *selectorName, id obj1, id obj2) {
		return [self _runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
	};
	
	[self context][@"runVoidInstanceWithNoParamter"] = ^(id instance, NSString *selectorName) {
		[self _runInstanceWithInstance:instance selector:selectorName obj1:nil obj2:nil];
	};
	
	[self context][@"runVoidInstanceWith1Paramter"] = ^(id instance, NSString *selectorName, id obj1) {
		[self _runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:nil];
	};
	
	[self context][@"runVoidInstanceWith2Paramters"] = ^(id instance, NSString *selectorName, id obj1, id obj2) {
		[self _runInstanceWithInstance:instance selector:selectorName obj1:obj1 obj2:obj2];
	};
	
	[self context][@"runInvocation"] = ^(NSInvocation *invocation) {
		[invocation invoke];
	};
	
	// helper
	[[self context] evaluateScript:@"var console = {}"];
	[self context][@"console"][@"log"] = ^(id message) {
		NSLog(@"Javascript log: %@",message);
	};
}


@end
























