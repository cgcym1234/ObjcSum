//
//  NSKeyedUnarchiver+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedUnarchiver (YYExtension)

/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (id)yy_unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception;

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (id)yy_unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception;

@end
