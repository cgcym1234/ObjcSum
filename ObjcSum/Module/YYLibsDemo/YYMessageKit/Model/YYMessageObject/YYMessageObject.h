//
//  YYMessageObject.h
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageDefinition.h"


@class YYMessage;
/**
 *  消息体协议
 */
@protocol YYMessageObject <NSObject>

/**
 *  消息体所在的消息对象
 */
@property (nonatomic, weak, readonly) YYMessage *message;

/**
 *  消息内容类型
 *
 *  @return 消息内容类型
 */
- (YYMessageType)type;

@end

