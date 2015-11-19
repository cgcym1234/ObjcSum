//
//  YYTextView.h
//  MLLCustomer
//
//  Created by sihuan on 15/4/28.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInputAccessoryViewWithCancel.h"

@class YYTextView;
@protocol YYTextViewDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView;
- (BOOL)textViewShouldEndEditing:(YYTextView *)textView;
- (BOOL)textViewShouldReturn:(YYTextView *)textView;

- (void)textViewDidBeginEditing:(YYTextView *)textView;
- (void)textViewDidEndEditing:(YYTextView *)textView;

- (void)textViewDidChange:(YYTextView *)textView;
- (void)textViewDidChangeSelection:(YYTextView *)textView;

@end

//类型是取消和完成
typedef void (^YYTextViewDidClickedAccessoryBlock)(YYTextView *view, YYInputAccessoryViewWithCancelType type, NSString *text);

#pragma mark - 附带placeHolder和字数限制的UITextView
@interface YYTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UILabel *maxcharNumLabel;

//限制输入个数，设置大于0会显示 maxcharNumLabel
@property (nonatomic,assign) NSUInteger maxCharNum;

//是否显示限制字数的label，
@property (nonatomic,assign) BOOL maxCharNumShow;

@property (nonatomic,assign) id<YYTextViewDelegate> yyDelegate;

//在键盘上加一个辅助条
@property (nonatomic, strong) YYInputAccessoryViewWithCancel *accessoryView;
//是否显示辅助条，默认不显示
@property (nonatomic,assign) BOOL accessoryViewShow;

@property (nonatomic, copy) YYTextViewDidClickedAccessoryBlock didClickedAccessoryBlock;

@end
