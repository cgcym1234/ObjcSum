//
//  YYMessageInputToolManager.m
//  ObjcSum
//
//  Created by sihuan on 16/1/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageInputToolManager.h"
#import "UIView+YYMessage.h"
#import "YYKeyboardManager.h"

#pragma mark - Consts

static NSInteger const HeightForInputToolBar = 49;

#pragma mark  Keys

static NSString * const KeyCell = @"KeyCell";

@interface YYMessageInputToolManager ()
<YYKeyboardObserver, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *assetsButton;
@property (nonatomic, strong) YYMessageInputToolBar *inputToolBar;

@end

@implementation YYMessageInputToolManager


#pragma mark - Initialization

- (instancetype)initWithDelegate:(id<YYMessageInputToolManagerDelegate>)delegate {
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    if (!mainWindow) mainWindow = [UIApplication sharedApplication].windows.firstObject;
    return [self initWithDelegate:delegate inputToolBarContainerView:mainWindow];
}

- (instancetype)initWithDelegate:(id<YYMessageInputToolManagerDelegate>)delegate
       inputToolBarContainerView:(UIView *)inputToolBarContainerView {
    if (self = [super init]) {
        self.delegate = delegate;
        self.inputToolBarContainerView = inputToolBarContainerView;
        [self setContext];
    }
    return self;
}

#pragma mark - Overrides

- (void)dealloc {
    _inputToolBar = nil;
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - Public methods


#pragma mark - Delegate

- (void)yyKeyboardManager:(YYKeyboardManager *)keyboardManager
   keyboardWithTransition:(YYKeyboardTransition)transition {
    CGRect keyboardFrame = [keyboardManager convertRect:transition.toFrame toView:_inputToolBarContainerView];
    CGRect originFrame = _inputToolBar.frame;
    _inputToolBar.bottom = keyboardFrame.origin.y;
    _inputToolBar.width = keyboardFrame.size.width;
    [_delegate yyMessageInputToolManager:self willTranslateToFrame:_inputToolBar.frame fromFrame:originFrame];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL ret = YES;
    
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        [_delegate yyMessageInputToolManager:self didSendMessage:_inputToolBar.inputTextView.text messageType:YYMessageTypeText];
        ret = NO;
    }
    return ret;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 200) {
//        [YYHud showTip:@"请将随手记内容保持在200个字以内"];
        NSString *text = [textView.text substringToIndex:200];
        textView.text = text;
        return;
    }
}

#pragma mark - Private methods

- (void)setContext {
    [self.inputToolBarContainerView addSubview:self.inputToolBar];
    _inputToolBar.width = _inputToolBarContainerView.width;
    _inputToolBar.height = HeightForInputToolBar;
    _inputToolBar.bottom = _inputToolBarContainerView.height;
    _inputToolBar.inputTextView.delegate = self;
    [[YYKeyboardManager defaultManager] addObserver:self];
}

#pragma mark - Setters


#pragma mark - Getters

- (YYMessageInputToolBar *)inputToolBar {
    if (!_inputToolBar) {
        YYMessageInputToolBar *toolBar = [YYMessageInputToolBar new];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _inputToolBar = toolBar;
    }
    return _inputToolBar;
}


@end
