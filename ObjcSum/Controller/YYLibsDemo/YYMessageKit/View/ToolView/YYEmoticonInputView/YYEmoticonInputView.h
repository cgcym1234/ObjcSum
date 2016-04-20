//
//  YYEmoticonInputView.h
//  ObjcSum
//
//  Created by sihuan on 16/3/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYEmoticonInputView;

@protocol YYEmoticonInputViewDelegate <NSObject>

@optional
- (void)yyEmoticonInputView:(YYEmoticonInputView *)view didTapText:(NSString *)text;
- (void)yyEmoticonInputViewDidTapBackspace:(YYEmoticonInputView *)view;
- (void)yyEmoticonInputViewDidTapSend:(YYEmoticonInputView *)view;

@end


/// 表情输入键盘
@interface YYEmoticonInputView : UIView

@property (nonatomic, weak) id<YYEmoticonInputViewDelegate> delegate;

+ (instancetype)instance;

@end
