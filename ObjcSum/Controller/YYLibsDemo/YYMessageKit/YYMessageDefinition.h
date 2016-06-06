//
//  YYMessageDefinition.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//


#ifndef YYMessageDefinition_h
#define YYMessageDefinition_h

#import <UIKit/UIKit.h>

//直接从RGB取颜色16进制(RGB 0xFF00FF)
#define ColorFromRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorFromRGB(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorFromRGBA(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark - 一些类型和选项定义

#define YYInputViewHeight (200)

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

#pragma mark - Delegates

@protocol YYCellDelegate <NSObject>

//@property (nonatomic, strong) id model;
//@property (nonatomic, weak) UIView *containerView;

@required
- (void)renderWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inContainer:(UIView *)containerView;

@optional
- (void)cellDidTaped:(id<YYCellDelegate>)cell;

@end



#endif /* YYMessageDefinition_h */
