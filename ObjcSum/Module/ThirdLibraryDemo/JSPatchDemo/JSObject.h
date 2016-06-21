//
//  JSObject.h
//  JS_OC
//
//  Created by chester on 16/3/17.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议


@protocol JSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
-(void) showShare;
-(void) showShareP1:(int)a;
-(void) showShareP2:(int)x And:(int)y;
@end



@interface JSObject : NSObject<JSObjectProtocol>



@end
