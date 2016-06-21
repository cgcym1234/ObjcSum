//
//  YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessage.h"
#import "YYMessageObjectImage.h"
#import "YYMessageObjectAudio.h"

@interface YYMessage ()

@property (nonatomic,assign) YYMessageType messageType;
@property (nonatomic,assign)       YYMessageDeliveryState deliveryState;
@property (nonatomic,copy)         NSString *messageId;
@property (nonatomic,copy)       NSString *session;
@property (nonatomic,copy)         NSString *senderName;
@property (nonatomic,copy)         NSString *senderID;
@property (nonatomic,copy)       NSDate *sendTime;
@property (nonatomic,assign)       BOOL isOutgoing;
@property (nonatomic,assign)       BOOL isDeleted;

@end

@implementation YYMessage

+ (instancetype)messageWithType:(YYMessageType)type content:(id)obj {
    YYMessage *message = [YYMessage new];
    message.senderName = @"rilong";
    message.isOutgoing = YES;
    message.messageType = type;
    id<YYMessageObject> messageObject;
    switch (type) {
        case YYMessageTypeText: {
            message.text = obj;
            break;
        }
        case YYMessageTypeImage: {
            messageObject = [[YYMessageObjectImage alloc] initWithImage:obj];
            break;
        }
        case YYMessageTypeAudio: {
            messageObject = [[YYMessageObjectAudio alloc] initWithAudioURL:obj];
            break;
        }
        case YYMessageTypeVideo: {
            break;
        }
        case YYMessageTypeLocation: {
            break;
        }
        case YYMessageTypeFile: {
            break;
        }
        case YYMessageTypeCustom: {
            break;
        }
    }
    message.messageObject = messageObject;
    return message;
}


#pragma mark - Demo

+ (instancetype)messageTextOutgoing {
    YYMessage *message = [YYMessage new];
    message.text = @"合法i呵呵呵呵呵呵呵呵呵呵呵";
    message.senderName = @"hehe";
    message.isOutgoing = YES;
    return message;
}
+ (instancetype)messageTextInComing {
    YYMessage *message = [YYMessage new];
    message.text = @"在Xcode开发调试App时，一旦遇到崩溃问题，开发者可以直接使用Xcode的调试器定位分析。\n但如果App发布上线，开发者不可能进行调试，只能通过分析系统记录的崩溃日志来定位问题，在这份崩溃日志文件中，会指出App出错的函数内存地址，而这些函数地址是可以在.dSYM文件中找到具体的文件名、函数名和行号信息的，这正是符号表的重要作用所在。";
    message.senderName = @"日龙包";
    message.isOutgoing = NO;
    return message;
}

+ (instancetype)messageImageInComing {
    YYMessage *message = [YYMessage new];
    message.messageObject = [[YYMessageObjectImage alloc] initWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
    message.senderName = @"日龙包";
    message.isOutgoing = NO;
    message.messageType = YYMessageTypeImage;
    return message;
}

@end
