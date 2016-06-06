//
//  YYMessageInputToolBar.m
//  ObjcSum
//
//  Created by sihuan on 16/1/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageInputToolBar.h"
#import "YYMessageAudioRecordButton.h"
#import "YYEmoticonInputView.h"
#import "UIButton+YYMessage.h"
#import "UIView+YYMessage.h"
#import "YYMessageDefinition.h"
#import "YYMessageMoreView.h"

#pragma mark - Consts

//static NSInteger const TextViewMarginTopBottom = 8;
static NSInteger const HeightDefault = 49;


#pragma mark  Keys

static NSString * const ImageInput = @"ChatWindow_Keyboard";
static NSString * const ImageVoice = @"ChatWindow_Speaking";
static NSString * const ImageEmoji = @"ChatWindow_Expression";
static NSString * const ImageMore = @"ChatWindow_More";

@interface YYMessageInputToolBar ()
<YYEmoticonInputViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *inputAndVoiceSwitchButton;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet YYMessageAudioRecordButton *voiceRecordButton;

@property (weak, nonatomic) IBOutlet UIButton *emojiButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiButtonWidth;

@property (assign, nonatomic) YYMessageInputToolBarState state;

@property (nonatomic, strong) YYEmoticonInputView *emoticonInputView;
@property (nonatomic, strong) YYMessageMoreView *moreView;

@end

@implementation YYMessageInputToolBar


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [_inputAndVoiceSwitchButton setTitle:nil forState:UIControlStateNormal];
    [_emojiButton setTitle:nil forState:UIControlStateNormal];
    [_moreButton setTitle:nil forState:UIControlStateNormal];
    
    
    _inputTextView.text = nil;
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.698 alpha:1.000].CGColor;
    _inputTextView.layer.borderWidth = 0.5;
    _inputTextView.layer.cornerRadius = 6;
    
    _voiceRecordButton.layer.borderColor = [UIColor colorWithWhite:0.698 alpha:1.000].CGColor;
    _voiceRecordButton.layer.borderWidth = 0.5;
    _voiceRecordButton.layer.cornerRadius = 6;
    [_voiceRecordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_inputTextView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    _state = YYMessageInputToolBarStateInput;
}

- (instancetype)init {
    return [YYMessageInputToolBar newInstanceFromNib];
}

- (void)dealloc {
    [_inputTextView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
}
#pragma mark - Overrides

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == _inputTextView && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        CGSize oldContentSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
        CGSize newContentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        NSLog(@"oldContentSize=%@, newContentSize=%@", NSStringFromCGSize(oldContentSize), NSStringFromCGSize(newContentSize));
        if (!CGSizeEqualToSize(oldContentSize, newContentSize)) {
            CGFloat offSet = newContentSize.height - oldContentSize.height;
            [self heightChangedWithOffset:offSet];
        }
    }
}


#pragma mark - Public methods


#pragma mark - Delegate

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL ret = YES;
    
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
//        [_delegate yyMessageInputToolManager:self didSendMessage:_inputToolBar.inputTextView.text messageType:YYMessageTypeText];
//        _inputToolBar.inputTextView.text = nil;
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

#pragma mark YYEmoticonInputViewDelegate

- (void)yyEmoticonInputView:(YYEmoticonInputView *)view didTapText:(NSString *)text {
    [_inputTextView replaceRange:_inputTextView.selectedTextRange withText:text];
}

- (void)yyEmoticonInputViewDidTapBackspace:(YYEmoticonInputView *)view {
    //    [_textView deleteBackward];
}

- (void)yyEmoticonInputViewDidTapSend:(YYEmoticonInputView *)view {
    [_inputTextView.delegate textView:_inputTextView shouldChangeTextInRange:NSMakeRange(0, 1) replacementText:@"\n"];
}

#pragma mark - Private methods

- (void)heightChangedWithOffset:(CGFloat)offSet {
    CGRect originFrame = self.frame;
    self.top -= offSet;
    self.height += offSet;
    //必须加上，否则，文字显示位置不对
    [_inputTextView layoutIfNeeded];
    
    [_delegate yyMessageInputToolBar:self willTranslateToFrame:self.frame fromFrame:originFrame];
}

- (void)switchFrameForStateVoiceAndText {
    if (self.height != HeightDefault) {
        [self heightChangedWithOffset:-(self.height - HeightDefault)];
    } else if (_inputTextView.height != _inputTextView.contentSize.height) {
        [self heightChangedWithOffset:_inputTextView.contentSize.height - _inputTextView.height];
    }
}

- (IBAction)didClickedSwitchButton:(YYMultiImageButton *)switchButton {
    self.state = _state != YYMessageInputToolBarStateVoiceRecord ? YYMessageInputToolBarStateVoiceRecord :YYMessageInputToolBarStateInput;
    [self switchFrameForStateVoiceAndText];
}

- (IBAction)didClickedEmojiButton:(UIButton *)sender {
    YYMessageInputToolBarState currentState = _state != YYMessageInputToolBarStateEmoji ? YYMessageInputToolBarStateEmoji :YYMessageInputToolBarStateInput;
    _inputTextView.inputView = currentState != YYMessageInputToolBarStateEmoji ? nil : self.emoticonInputView;
    [_inputTextView reloadInputViews];
    self.state = currentState;
}

- (IBAction)didClickedMoreButton:(UIButton *)sender {
    YYMessageInputToolBarState currentState = _state != YYMessageInputToolBarStateMore ? YYMessageInputToolBarStateMore :YYMessageInputToolBarStateInput;
    _inputTextView.inputView = currentState != YYMessageInputToolBarStateMore ? nil : self.moreView;
    [_inputTextView reloadInputViews];
    self.state = currentState;
}

- (void)setTextViewFirstResponder:(BOOL)isFirstResponder {
    isFirstResponder ? [_inputTextView becomeFirstResponder] : [_inputTextView resignFirstResponder];
}

#pragma mark - Setters

- (void)setState:(YYMessageInputToolBarState)state {
    _state = state;
    
    //文字输入状态配置
    BOOL textInputViewHidden = NO;
    NSString *inputAndVoiceSwitchButtonImage = ImageVoice;
    NSString *emojiButtonImage = ImageEmoji;
    NSString *moreButtonImage = ImageMore;
    
    
    switch (state) {
        case YYMessageInputToolBarStateInput: {
            break;
        }
        case YYMessageInputToolBarStateVoiceRecord: {
            inputAndVoiceSwitchButtonImage = ImageInput;
            textInputViewHidden = YES;
            break;
        }
        case YYMessageInputToolBarStateEmoji: {
            emojiButtonImage = ImageInput;
            break;
        }
        case YYMessageInputToolBarStateMore: {
            moreButtonImage = ImageInput;
            break;
        }
    }
    
    [_inputAndVoiceSwitchButton setImageNomalState:[UIImage imageNamed:inputAndVoiceSwitchButtonImage]];
    [_emojiButton setImageNomalState:[UIImage imageNamed:emojiButtonImage]];
    [_moreButton setImageNomalState:[UIImage imageNamed:moreButtonImage]];
    
    _inputTextView.hidden = textInputViewHidden;
    _voiceRecordButton.hidden = !textInputViewHidden;
    
    [self setTextViewFirstResponder:!textInputViewHidden];
    
    [_delegate yyMessageInputToolBar:self didChangeToState:_state];
}

#pragma mark - Getters

- (YYEmoticonInputView *)emoticonInputView {
    if (!_emoticonInputView) {
        YYEmoticonInputView *emoticonInputView = [YYEmoticonInputView instance];
        emoticonInputView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YYInputViewHeight);
        emoticonInputView.delegate = self;
        _emoticonInputView = emoticonInputView;
    }
    return _emoticonInputView;
}

- (YYMessageMoreView *)moreView {
    if (!_moreView) {
        YYMessageMoreView *moreView = [YYMessageMoreView new];
//        moreView.delegate = self;
        _moreView = moreView;
    }
    return _moreView;
}


@end