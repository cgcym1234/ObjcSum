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
    [_inputToolBar.inputTextView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _inputToolBar.inputTextView && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        CGSize oldContentSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
        CGSize newContentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        NSLog(@"oldContentSize=%@, newContentSize=%@", NSStringFromCGSize(oldContentSize), NSStringFromCGSize(newContentSize));
        if (!CGSizeEqualToSize(oldContentSize, newContentSize)) {
            CGRect originFrame = _inputToolBar.frame;
            CGFloat offSet = newContentSize.height-oldContentSize.height;
            _inputToolBar.y -= offSet;
            _inputToolBar.height += offSet;
            [_delegate yyMessageInputToolManager:self willTranslateToFrame:_inputToolBar.frame fromFrame:originFrame];
            //必须加上，否则，文字显示位置不对
            [_inputToolBar.inputTextView layoutIfNeeded];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL ret = YES;
    
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        [_delegate yyMessageInputToolManager:self didSendMessage:_inputToolBar.inputTextView.text messageType:YYMessageTypeText];
        _inputToolBar.inputTextView.text = nil;
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
    __weak typeof(self)weakSelf = self;
    
    [self.inputToolBarContainerView addSubview:self.inputToolBar];
    _inputToolBar.width = _inputToolBarContainerView.width;
    _inputToolBar.height = HeightForInputToolBar;
    _inputToolBar.bottom = _inputToolBarContainerView.height;
    _inputToolBar.inputTextView.delegate = self;
    _inputToolBar.voiceRecordButton.completeBlock = ^(YYMessageAudioRecordButton *view, NSURL *voicePath) {
        [weakSelf.delegate yyMessageInputToolManager:weakSelf didSendMessage:voicePath messageType:YYMessageTypeAudio];
    };
    [[YYKeyboardManager defaultManager] addObserver:self];
    [_inputToolBar.inputTextView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    _height = HeightForInputToolBar;
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
