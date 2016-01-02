//
//  YYMessageCellLayoutConfig.h
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageTextLabel.h"


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

//默认40
@property (nonatomic, assign) CGFloat avatarImageViewWH;

@property (nonatomic, strong) UIFont *cellTopLabelFont;
@property (nonatomic, strong) UIFont *bubbleTopLabelFont;
@property (nonatomic, strong) UIFont *cellBottomLabelFont;
@property (nonatomic, strong) UIFont *messageTextLabelFont;

@property (nonatomic, strong) UIColor *cellTopLabelColor;
@property (nonatomic, strong) UIColor *bubbleTopLabelColor;
@property (nonatomic, strong) UIColor *cellBottomLabelColor;
@property (nonatomic, strong) UIColor *messageTextLabelColor;

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

//用于计算文本大小
@property (nonatomic, strong) YYMessageTextLabel *messageTextLabel;

+ (instancetype)defaultConfig;

/**
 *  修改配置
 */
+ (void)config:(void(^)(YYMessageCellConfig *config))cofig;

@end
