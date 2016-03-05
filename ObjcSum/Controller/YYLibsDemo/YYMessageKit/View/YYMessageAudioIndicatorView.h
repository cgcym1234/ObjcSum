//
//  YYMessageAudioIndicatorView.h
//  ObjcSum
//
//  Created by sihuan on 16/3/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYMessageAudioIndicatorViewState) {
    YYMessageAudioIndicatorViewStateRecording,
    YYMessageAudioIndicatorViewStateCanceling,
};

@interface YYMessageAudioIndicatorView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, assign, readonly) CGFloat seconds;
@property (nonatomic, assign) YYMessageAudioIndicatorViewState state;


+ (void)show;
+ (void)dismiss;
+ (void)setState:(YYMessageAudioIndicatorViewState)state;

@end
