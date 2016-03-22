//
//  NSDate+YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 16/1/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YYMessage)

//默认yyyy/mm/dd
- (NSString *)stringWithDefaultFormat;
- (NSString *)stringWithFormat:(NSString *)format;
@end
