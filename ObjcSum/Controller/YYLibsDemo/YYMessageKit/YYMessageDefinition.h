//
//  YYMessageDefinition.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#ifndef YYMessageDefinition_h
#define YYMessageDefinition_h

#pragma mark - 一些类型和选项定义

/**
 *  消息内容类型枚举
 */
typedef NS_ENUM(NSInteger, YYMessageType) {
    /**
     *  文本类型消息
     */
    YYMessageTypeText = 0,
    /**
     *  图片类型消息
     */
    YYMessageTypeImage,
    /**
     *  声音类型消息
     */
    YYMessageTypeAudio,
    /**
     *  视频类型消息
     */
    YYMessageTypeVideo,
    /**
     *  位置类型消息
     */
    YYMessageTypeLocation,
    /**
     *  文件类型消息
     */
    YYMessageTypeFile,
    /**
     *  自定义类型消息
     */
    YYMessageTypeCustom = 100,
};

/**
 *  消息送达状态枚举
 */
typedef NS_ENUM(NSInteger, YYMessageDeliveryState){
    /**
     *  消息发送失败
     */
    YYMessageDeliveryStateFailed,
    /**
     *  消息发送中
     */
    YYMessageDeliveryStateDelivering,
    /**
     *  消息发送成功
     */
    YYMessageDeliveryStateDelivered
};

#endif /* YYMessageDefinition_h */
