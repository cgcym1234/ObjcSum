//
//  FastRecordVoiceButton.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FastRecordVoiceButtonActionType) {
    FastRecordVoiceButtonActionTypePlay,    //播放
    FastRecordVoiceButtonActionTypeDelete,  //删除
};


@class FastRecordVoiceButton;

typedef void (^FastRecordVoiceButtonDidClickedBlock)(FastRecordVoiceButton *btn, FastRecordVoiceButtonActionType actionType);

@interface FastRecordVoiceButton : UIView

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, copy) FastRecordVoiceButtonDidClickedBlock didClickedBlock;

@property (nonatomic, strong) NSURL *filePath;
@property (nonatomic, strong,readonly) NSURL *voiceURL;


@property (nonatomic, copy) NSString *text;
//默认是yes
@property (nonatomic, assign) BOOL showDeleteButton;

+ (instancetype)instanceFromNib;

- (void)setVoiceWithURL:(NSURL*)url;

#pragma mark - event
- (void)play;
- (void)cancel;

@end
