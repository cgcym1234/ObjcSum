//
//  YYMessageInputToolBar.h
//  ObjcSum
//
//  Created by sihuan on 16/1/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMultiImageButton.h"

typedef NS_ENUM(NSUInteger, YYMessageInputToolBarItemType) {
    YYMessageInputToolBarItemTypeSwitchButton,
};

@interface YYMessageInputToolBar : UIView

@property (weak, nonatomic, readonly) YYMultiImageButton *inputAndVoiceSwitchButton;

@property (weak, nonatomic, readonly) UITextView *inputTextView;
@property (weak, nonatomic, readonly) UIButton *voiceRecordButton;

@property (weak, nonatomic, readonly) UIButton *emojiButton;
@property (weak, nonatomic, readonly) UIButton *moreButton;



#pragma mark - Public methods

- (instancetype)init;


@end
