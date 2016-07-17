//
//  YYMessageAudioRecordButton.h
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYMessageAudioRecordButtonState) {
    YYMessageAudioRecordButtonStateTouchDown = 1,
    YYMessageAudioRecordButtonStateTouchUpInside,
    YYMessageAudioRecordButtonStateTouchUpOutside,
    YYMessageAudioRecordButtonStateTouchDragOutside,
    YYMessageAudioRecordButtonStateTouchDragInside,
};

@class YYMessageAudioRecordButton;

typedef void (^YYMessageAudioRecordButtonCompleteBlock)(YYMessageAudioRecordButton *view, NSURL *voicePath);

@interface YYMessageAudioRecordButton : UIButton

@property (nonatomic, assign, readonly) BOOL isRocording;
@property (nonatomic, assign, readonly) YYMessageAudioRecordButtonState  recordState;
@property (nonatomic, copy) YYMessageAudioRecordButtonCompleteBlock completeBlock;

@end
