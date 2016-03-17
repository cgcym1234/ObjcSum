//
//  ProtocolAndCategory.h
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 第四章 协议与分类

@protocol ProtocolAndCategoryDelegate <NSObject>

@optional
- (void)protocolAndCategoryDelegate1;
- (void)protocolAndCategoryDelegate2;
- (void)protocolAndCategoryDelegate3;

@end

@interface ProtocolAndCategory : NSObject

#pragma mark - 通过协议提供匿名对象
@property (nonatomic, weak) id<ProtocolAndCategoryDelegate> delegate;

@end
