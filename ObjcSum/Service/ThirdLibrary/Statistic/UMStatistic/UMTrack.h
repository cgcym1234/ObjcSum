//
//  UMTrack.h
//  MLLCustomer
//
//  Created by sihuan on 15/9/17.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMTrack : NSObject

/**
 *  添加友盟的umtrack功能
 */
+ (void)startWithAppkey:(NSString *)appKey;

@end
