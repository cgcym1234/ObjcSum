//
//  YYAudioPlayButton.h
//  ObjcSum
//
//  Created by sihuan on 16/3/14.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YYMessage.h"

typedef NS_ENUM(NSUInteger, YYAudioPlayButtonType) {
    YYAudioPlayButtonTypeVoiceLeft = 0,   //播放图片在左边
    YYAudioPlayButtonTypeVoiceRight,  //播放图片在右边
};


@class YYAudioPlayButton;

typedef void (^YYAudioPlayButtonDidTapBlock)(YYAudioPlayButton *btn);

@interface YYAudioPlayButton : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) YYAudioPlayButtonDidTapBlock didTapBlock;

@property (nonatomic, strong) NSURL *audioURL;

//毫秒
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) YYAudioPlayButtonType type;


#pragma mark - Public

- (void)setAudioURL:(NSURL *)audioURL duration:(NSInteger)duration;
- (void)play;
- (void)stopPlaying;

@end
