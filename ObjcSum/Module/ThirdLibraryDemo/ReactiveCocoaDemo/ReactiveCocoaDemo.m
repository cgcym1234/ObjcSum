//
//  ReactiveCocoaDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2016/9/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ReactiveCocoaDemo.h"

@interface ReactiveCocoaDemo ()

@end

@implementation ReactiveCocoaDemo


/**
 在编写iOS代码时，我们的大部分代码都是在响应一些事件：按钮点击、接收网络消息、属性变化等等。但是这些事件在代码中的表现形式却不一样：如target-action、代理方法、KVO、回调或其它。ReactiveCocoa的目的就是定义一个统一的事件处理接口，这样它们可以非常简单地进行链接、过滤和组合。
 
 ReactiveCocoa结合了一些编程模式：
 
 1. 函数式编程：利用高阶函数，即将函数作为其它函数的参数。
 2. 响应式编程：关注于数据流及变化的传播。
 
 基于以上两点，ReactiveCocoa被当成是函数响应编程(Functional Reactive Programming, FRP)框架。我们将在下面以实例来看看ReactiveCocoa的实用价值。
 
 ReactiveCocoa提供了一个标准的接口来处理不同的事件流。在ReactiveCocoa中，这些被统一称为信号，由RACSignal类表示。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
}


@end
