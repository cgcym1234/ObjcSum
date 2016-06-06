//
//  YYMessageCellLayoutConfig.h
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageTextLabel.h"

#define YYColorFromRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - 配置参数


@class YYMessageTextLabel;
@class YYMessageModel;

@protocol YYMessageCellLayoutConfig <NSObject>

@required

//计算消息内容大小的协议
+ (CGSize)contentSize:(YYMessageModel *)model cellWidth:(CGFloat)width;

@end

@interface YYMessageCellConfig : NSObject

/**
    默认都是20，
 *  cellTopLabel显示时间
 bubbleTopLabel和cellBottomLabel目前都用来显示昵称
 */
@property (nonatomic, assign) CGFloat cellTopLabelHeight;
@property (nonatomic, assign) CGFloat bubbleTopLabelHeight;
@property (nonatomic, assign) CGFloat cellBottomLabelHeight;

//气泡箭头宽度，默认10
@property (nonatomic, assign) CGFloat bubbleArrowWith;

//默认40
@property (nonatomic, assign) CGFloat avatarImageViewWH;

@property (nonatomic, strong) UIFont *cellTopLabelFont;
@property (nonatomic, strong) UIFont *bubbleTopLabelFont;
@property (nonatomic, strong) UIFont *cellBottomLabelFont;
@property (nonatomic, strong) UIFont *messageTextLabelFont;

@property (nonatomic, strong) UIColor *cellTopLabelColor;
@property (nonatomic, strong) UIColor *cellBottomLabelColor;
@property (nonatomic, strong) UIColor *bubbleTopLabelColor;

@property (nonatomic, strong) UIColor *bubbleColorIncoming;
@property (nonatomic, strong) UIColor *bubbleColorOutgoing;
@property (nonatomic, strong) UIColor *messageTextColorIncoming;
@property (nonatomic, strong) UIColor *messageTextColorOutgoing;

//背景色
@property (nonatomic, strong) UIColor *messageBackgroundColor;

//显示bubbleTopLabel，默认YES，
@property (nonatomic, assign) BOOL bubbleTopLabelShow;

//显示cellBottomLabel，默认NO，
@property (nonatomic, assign) BOOL cellBottomLabelShow;

/**
 *  头像是否显示在上面,默认YES
 如果设置成NO,那么头像会显示在下面
 且bubbleTopLabelShow会被自动设置成NO,
 cellBottomLabelShow被自动设置成YES
 
 如果需要bubbleTopLabel和cellBottomLabel显示不同内容，需要少量调整源码
 */
@property (nonatomic, assign) BOOL avatarImageViewShowAtTop;

@property (nonatomic, assign) UIEdgeInsets contentViewInsets;
@property (nonatomic, assign) UIEdgeInsets bubbleViewInsets;

//预览小图的尺寸限制
@property (nonatomic, assign) CGSize attachmentImageSizeMax;
@property (nonatomic, assign) CGSize attachmentImageSizeMin;

//用于计算文本大小的lable
@property (nonatomic, strong) YYMessageTextLabel *messageTextLabel;

+ (instancetype)defaultConfig;

/**
 *  修改配置
 */
+ (void)config:(void(^)(YYMessageCellConfig *config))cofig;

@end
