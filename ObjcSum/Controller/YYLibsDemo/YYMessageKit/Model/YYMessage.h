//
//  YYMessage.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageDefinition.h"
#import "YYMessageSetting.h"
/**
 *  消息结构
 */
@interface YYMessage : NSObject

/**
 *  消息类型
 */
@property (nonatomic, assign, readonly) YYMessageType messageType;

/**
 *  消息投递状态 仅针对发送的消息
 */
@property (nonatomic,assign,readonly)       YYMessageDeliveryState deliveryState;

/**
 *  消息设置
 *  @discussion 可以通过这个字段制定当前消息的各种设置,如是否需要计入未读，是否需要多端同步等
 */
@property (nonatomic, strong) YYMessageSetting *messageSetting;

/**
 *  消息ID,唯一标识
 */
@property (nonatomic, copy, readonly)         NSString *messageId;

/**
 *  消息来源
 */
@property (nonatomic,copy)                  NSString *from;

/**
 *  消息所属会话
 */
@property (nonatomic,copy,readonly)       NSString *session;

/**
 *  消息发送者名字
 *  @discussion 这个值表示的是发送者当前的昵称,而不是发送消息时的昵称
 */
@property (nonatomic,copy,readonly)         NSString *senderName;

/**
 *  消息发送者ID
 *  @discussion 这个id应该是唯一的
 */
@property (nonatomic,copy,readonly)         NSString *senderID;

/**
 *  消息文本
 */
@property (nonatomic,copy)                  NSString *text;

/**
 *  消息推送文案,长度限制200字节
 */
@property (nonatomic,copy)                  NSString *apnsContent;

/**
 *  消息发送时间
 */
@property (nonatomic,copy,readonly)       NSDate *sendTime;

/**
 *  是否是往外发的消息
 *  @discussion 这个字段用于判断头像排版位置（是左还是右）。
 */
@property (nonatomic,assign,readonly)       BOOL isOutgoing;

/**
 *  消息是否标记为已删除
 *  @discussion 已删除的消息在获取本地消息列表时会被过滤掉，只有根据messageId获取消息的接口可能会返回已删除消息。
 */
@property (nonatomic,assign,readonly)       BOOL isDeleted;


+ (instancetype)messageTextOutgoing;
+ (instancetype)messageTextInComing;

@end






























