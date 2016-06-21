//
//  FastRecordVoiceInputView.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FastRecordVoiceInputView;

typedef void (^FastRecordVoiceInputViewDidCompletedBlock)(FastRecordVoiceInputView *view, NSURL *voicePath, NSTimeInterval duration);

@interface FastRecordVoiceInputView : UIView

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@property (nonatomic, copy) FastRecordVoiceInputViewDidCompletedBlock didCompletedBlock;
//是否取消录音
@property (nonatomic, assign, readwrite) BOOL isCancelled;

//是否正在录音
@property (nonatomic, assign, readwrite) BOOL isRecording;

+ (instancetype)instanceFromNib;

@end
