//
//  JSObject.m
//  JS_OC
//
//  Created by chester on 16/3/17.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "JSObject.h"



@implementation JSObject

-(void) showShare
{
    NSLog(@"showShare");
}

-(void) showShareP1:(int)a
{
    NSLog(@"showShareP1 %d", a);
}

-(void) showShareP2:(int)x And:(int)y
{
    NSLog(@"showShareP2 %d, %d ", x, y);
}

@end
