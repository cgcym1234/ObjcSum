//
//  YYMessageInputToolBar.m
//  ObjcSum
//
//  Created by sihuan on 16/1/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageInputToolBar.h"
#import "YYMessageAudioRecordButton.h"
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

@property (weak, nonatomic) IBOutlet UIButton *emojiButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiButtonWidth;

@property (nonatomic, assign) BOOL switchButton;
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
    [_emojiButton setImage:[UIImage imageNamed:EmojiButtonImage] forState:UIControlStateNormal];
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
    BOOL inputTextViewShow = switchButton.currentImageIndex == 0;
    _inputTextView.hidden = !inputTextViewShow;
    _voiceRecordButton.hidden = inputTextViewShow;
    
    if (inputTextViewShow) {
        [_inputTextView becomeFirstResponder];
    } else {
        [_inputTextView resignFirstResponder];
    }
}

- (IBAction)didClickedEmojiButton:(UIButton *)sender {
}

- (IBAction)didClickedMoreButton:(UIButton *)sender {
}

#pragma mark - Setters


#pragma mark - Getters



@end