//
//  YYMessageInputToolManager.h
//  ObjcSum
//
//  Created by sihuan on 16/1/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageDefinition.h"
#import "YYMessageInputToolBar.h"

@class YYMessageInputToolManager;

@protocol YYMessageInputToolManagerDelegate <NSObject>

@required

- (void)yyMessageInputToolManager:(YYMessageInputToolManager *)manager didSendMessage:(id)messageObj messageType:(YYMessageType)messageType;
- (void)yyMessageInputToolManager:(YYMessageInputToolManager *)manager willTranslateToFrame:(CGRect)toFrame fromFrame:(CGRect)fromFrame;

@end

@interface YYMessageInputToolManager : UIView

@property (nonatomic, weak) id<YYMessageInputToolManagerDelegate> delegate;

@property (nonatomic, weak) UIView *inputToolBarContainerView;

#pragma mark - Public

- (instancetype)initWithDelegate:(id<YYMessageInputToolManagerDelegate>)delegate;
- (instancetype)initWithDelegate:(id<YYMessageInputToolManagerDelegate>)delegate
       inputToolBarContainerView:(UIView *)inputToolBarContainerView;

@end
