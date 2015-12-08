//
//  TestJSObjectProtocol.h
//  ObjcSum
//
//  Created by sihuan on 15/12/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol JSExportDemo <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(void)TestOneParameter:(NSString *)message;
-(void)TestTowParameter:(NSString *)message1 secondParameter:(NSString *)message2;

@end

//让我们创建的类实现上边的协议
@interface JSExportDemoTest : NSObject<JSExportDemo>

@end
