//
//  TestJSObjectProtocol.m
//  ObjcSum
//
//  Created by sihuan on 15/12/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "TestJSObjectProtocol.h"

//让我们创建的类实现上边的协议
@implementation JSExportDemoTest

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter
{
    NSLog(@"this is ios TestNOParameter");
}
-(void)TestOneParameter:(NSString *)message
{
    NSLog(@"this is ios TestOneParameter=%@",message);
}
-(void)TestTowParameter:(NSString *)message1 secondParameter:(NSString *)message2
{
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}

@end
