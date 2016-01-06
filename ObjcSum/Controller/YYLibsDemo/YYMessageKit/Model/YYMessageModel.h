//
//  YYMessageModel.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessage.h"
#import "YYMessageCellLayoutConfig.h"

@interface YYMessageModel : NSObject

@property (nonatomic, strong) YYMessage *message;
@property (nonatomic, copy) NSString *displaySendTime;

/**
 *  内容大小
 */
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, readonly) NSString *cellIdentifier;

@property (nonatomic, readonly) UIEdgeInsets contentViewInsets;
@property (nonatomic, readonly) UIEdgeInsets bubbleViewInsets;

@property (nonatomic, readonly) BOOL shouldShowAvatar;
@property (nonatomic, readonly) BOOL shouldShowNickName;

@property (nonatomic, weak) Class<YYMessageCellLayoutConfig> cellLayoutDelegate;

- (instancetype)initWithMessage:(YYMessage*)message;
+ (instancetype)modelWithMessage:(YYMessage*)message;

/**
 *  计算内容大小
 *
 *  @param width cell宽度
 */
- (void)calculateSizeInWidth:(CGFloat)width;

/**
 *  清除缓存的布局数据，contentSize，cellHeight
 */
- (void)cleanCacheLayout;

@end
