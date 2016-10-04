//
//  RWSignInService.h
//  ObjcSum
//
//  Created by yangyuan on 2016/9/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RWSignInResponse)(BOOL);

@interface RWSignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end

