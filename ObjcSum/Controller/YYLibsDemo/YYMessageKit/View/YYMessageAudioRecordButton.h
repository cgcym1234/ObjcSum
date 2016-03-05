//
//  YYMessageAudioRecordButton.h
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYMessageAudioRecordButtonState) {
    YYMessageAudioRecordButtonStateTouchDown,
    YYMessageAudioRecordButtonStateTouchUpInside,
    YYMessageAudioRecordButtonStateTouchUpOutside,
    YYMessageAudioRecordButtonStateTouchDragOutside,
    YYMessageAudioRecordButtonStateTouchDragInside,
};

@class YYMessageAudioRecordButton;

typedef void (^YYMessageAudioRecordButtonCompleteBlock)(YYMessageAudioRecordButton *view, NSURL *voicePath, NSTimeInterval duration);

@interface YYMessageAudioRecordButton : UIButton

@property (nonatomic, assign, readonly) YYMessageAudioRecordButtonState  recordState;
@property (nonatomic, copy) YYMessageAudioRecordButtonCompleteBlock completeBlock;

@end
