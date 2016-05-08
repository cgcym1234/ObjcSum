//
//  YYMessageInputToolBar.h
//  ObjcSum
//
//  Created by sihuan on 16/1/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMultiImageButton.h"
#import "YYMessageAudioRecordButton.h"

typedef NS_ENUM(NSUInteger, YYMessageInputToolBarState) {
    YYMessageInputToolBarStateInput = 0,//输入文字状态
    YYMessageInputToolBarStateVoiceRecord,//录音状态
    YYMessageInputToolBarStateEmoji,//显示表情键盘状态
    YYMessageInputToolBarStateMore//显示点击更多状态
};

@class YYMessageInputToolBar;

@protocol YYMessageInputToolBarDelegate <NSObject>

@required
- (void)yyMessageInputToolBar:(YYMessageInputToolBar *)inputToolBar didChangeToState:(YYMessageInputToolBarState)state;
- (void)yyMessageInputToolBar:(YYMessageInputToolBar *)inputToolBar heightWillChangeTo:(CGFloat)height;
- (void)yyMessageInputToolBar:(YYMessageInputToolBar *)inputToolBar heightDidChangeTo:(CGFloat)height;

@end

@interface YYMessageInputToolBar : UIView

@property (weak, nonatomic, readonly) UIButton *inputAndVoiceSwitchButton;

@property (weak, nonatomic, readonly) UITextView *inputTextView;
@property (weak, nonatomic, readonly) YYMessageAudioRecordButton *voiceRecordButton;

@property (weak, nonatomic, readonly) UIButton *emojiButton;
@property (weak, nonatomic, readonly) UIButton *moreButton;
@property (weak, nonatomic) id<YYMessageInputToolBarDelegate> delegate;
@property (assign, nonatomic, readonly) YYMessageInputToolBarState state;


#pragma mark - Public methods

- (instancetype)init;


@end
