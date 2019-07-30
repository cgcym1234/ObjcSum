//
//  MethodForword.h
//  ObjcSum
//
//  Created by sihuan on 16/3/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MethodParent : NSObject

@end

@interface MethodForword : MethodParent

- (void)test;
+ (void)test;

- (NSString *)test2:(NSString *)name;

@end
