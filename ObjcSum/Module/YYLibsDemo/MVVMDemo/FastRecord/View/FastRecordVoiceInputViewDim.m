//
//  FastRecordVoiceInputViewDim.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordVoiceInputViewDim.h"

@implementation FastRecordVoiceInputViewDim

+ (instancetype)shareInstance {
    static FastRecordVoiceInputViewDim *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [FastRecordVoiceInputViewDim instanceFromNib];
        _shareInstance.translatesAutoresizingMaskIntoConstraints = YES;
        _shareInstance.userInteractionEnabled = YES;
    });
    return _shareInstance;
}


#pragma mark - Public

- (void)setText:(NSString *)text {
    _text = text;
    _textLabel.text = text;
}

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

+ (instancetype)showMarginBottom:(CGFloat)marginBottom {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    FastRecordVoiceInputViewDim *dimView = [FastRecordVoiceInputViewDim shareInstance];
    
    if (dimView.superview) {
        [dimView removeFromSuperview];
    }
    
    dimView.frame = CGRectMake(0, 0, CGRectGetWidth(keyWindow.bounds), CGRectGetHeight(keyWindow.bounds) - marginBottom);
    [keyWindow addSubview:dimView];
    return dimView;
}

+ (void)dismiss {
    [[FastRecordVoiceInputViewDim shareInstance] removeFromSuperview];
}

@end
