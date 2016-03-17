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
#import "UIView+YYMessage.h"

#pragma mark - Consts

//static NSInteger const HeightForCommonCell = 49;

#pragma mark  Keys

static NSString * const SwitchButtonImageInput = @"ChatWindow_Keyboard";
static NSString * const SwitchButtonImageVoice = @"ChatWindow_Speaking";
static NSString * const EmojiButtonImage = @"ChatWindow_Expression";
static NSString * const MoreButtonImage = @"ChatWindow_More";

@interface YYMessageInputToolBar ()

@property (weak, nonatomic) IBOutlet YYMultiImageButton *inputAndVoiceSwitchButton;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet YYMessageAudioRecordButton *voiceRecordButton;

@property (weak, nonatomic) IBOutlet YYMultiImageButton *emojiButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiButtonWidth;

//语音和输入按钮状态
@property (nonatomic, assign) BOOL isVoiceButtonVisible;

//表情和输入按钮状态
@property (nonatomic, assign) BOOL isEmojiButtonVisible;
@property (nonatomic, strong) YYEmoticonInputView *emoticonInputView;

@end

@implementation YYMessageInputToolBar


#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.backgroundColor = [UIColor whiteColor];
    
    [_inputAndVoiceSwitchButton setTitle:nil forState:UIControlStateNormal];
    [_emojiButton setTitle:nil forState:UIControlStateNormal];
    [_moreButton setTitle:nil forState:UIControlStateNormal];
    
    
    _inputAndVoiceSwitchButton.images = @[[UIImage imageNamed:SwitchButtonImageVoice],[UIImage imageNamed:SwitchButtonImageInput]];
    
//    [_emojiButton setImage:[UIImage imageNamed:EmojiButtonImage] forState:UIControlStateNormal];
    _emojiButton.images = @[[UIImage imageNamed:EmojiButtonImage],[UIImage imageNamed:SwitchButtonImageInput]];
    
    [_moreButton setImage:[UIImage imageNamed:MoreButtonImage] forState:UIControlStateNormal];
    
    _inputTextView.text = nil;
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.698 alpha:1.000].CGColor;
    _inputTextView.layer.borderWidth = 0.5;
    _inputTextView.layer.cornerRadius = 6;
    
    _voiceRecordButton.layer.borderColor = [UIColor colorWithWhite:0.698 alpha:1.000].CGColor;
    _voiceRecordButton.layer.borderWidth = 0.5;
    _voiceRecordButton.layer.cornerRadius = 6;
    [_voiceRecordButton setTitle:@"按住说话" forState:UIControlStateNormal];
}

- (instancetype)init {
    return [YYMessageInputToolBar newInstanceFromNib];
}

#pragma mark - Overrides


#pragma mark - Public methods


#pragma mark - Delegate


#pragma mark - Private methods

- (IBAction)didClickedSwitchButton:(YYMultiImageButton *)switchButton {
    
    //当前是语音图标，显示输入框
    BOOL inputTextViewShow = self.isVoiceButtonVisible;
    _inputTextView.hidden = !inputTextViewShow;
    _voiceRecordButton.hidden = inputTextViewShow;
    
    if (inputTextViewShow) {
        [_inputTextView becomeFirstResponder];
    } else {
        [_inputTextView resignFirstResponder];
    }
}

- (IBAction)didClickedEmojiButton:(UIButton *)sender {
    BOOL isEmojiButtonVisible = self.isEmojiButtonVisible;
    _inputTextView.inputView = isEmojiButtonVisible ? nil : self.emoticonInputView;
    [_inputTextView reloadInputViews];
    [_inputTextView becomeFirstResponder];
}

- (IBAction)didClickedMoreButton:(UIButton *)sender {
}

#pragma mark - Setters


#pragma mark - Getters

- (BOOL)isVoiceButtonVisible {
    return _inputAndVoiceSwitchButton.currentImageIndex == 0;
}

- (BOOL)isEmojiButtonVisible {
    return _emojiButton.currentImageIndex == 0;
}

- (YYEmoticonInputView *)emoticonInputView {
    if (!_emoticonInputView) {
        YYEmoticonInputView *emoticonInputView = [[YYEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _emoticonInputView = emoticonInputView;
    }
    return _emoticonInputView;
}


@end