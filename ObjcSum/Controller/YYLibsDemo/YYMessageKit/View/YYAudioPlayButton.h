//
//  YYAudioPlayButton.h
//  ObjcSum
//
//  Created by sihuan on 16/3/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YYMessage.h"

typedef NS_ENUM(NSUInteger, YYAudioPlayButtonActionType) {
    YYAudioPlayButtonActionTypePlay,    //播放
    YYAudioPlayButtonActionTypeDelete,  //删除
};


@class YYAudioPlayButton;

typedef void (^YYAudioPlayButtonDidClickBlock)(YYAudioPlayButton *btn, YYAudioPlayButtonActionType actionType);

@interface YYAudioPlayButton : UIView

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, copy) YYAudioPlayButtonDidClickBlock didClickBlock;

@property (nonatomic, strong) NSURL *audioURL;

//毫秒
@property (nonatomic, assign) NSInteger duration;

//默认是yes
@property (nonatomic, assign) BOOL showDeleteButton;

#pragma mark - Public

- (void)setAudioURL:(NSURL *)audioURL duration:(NSInteger)duration;
- (void)play;
- (void)stopPlaying;

@end
