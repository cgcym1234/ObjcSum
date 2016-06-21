//
//  FastRecordTextInputCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordTextInputCell.h"
#import "NSString+Extention.h"
#import "YYHud.h"

#import "FastRecordAccessoryView.h"
#import "FastRecordVoiceInputView.h"
#import "FastRecordVoiceInputViewDim.h"

@interface FastRecordTextInputCell ()

@property (nonatomic, strong) FastRecordVoiceInputView *inputView;
@property (nonatomic, strong) FastRecordAccessoryView *inputAccessory;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewMaxHeight;

@property (nonatomic, assign) CGFloat textViewContentSizeHeigth;
@property (nonatomic, assign) CGFloat keyboardHeigth;

@end

@implementation FastRecordTextInputCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _textView.placeHolder = @"输入备注信息";
    _textView.placeHolderLabel.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1];
    _textView.placeHolderLabel.font = [UIFont systemFontOfSize:16];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.yyDelegate = self;
    
    __weak typeof(self) weakSelf = self;
    FastRecordAccessoryView *accessoryView = [FastRecordAccessoryView instanceFromNib];
    accessoryView.didClickedBlock = ^(FastRecordAccessoryView *view, FastRecordAccessoryViewType currentType) {
        weakSelf.textView.inputView = currentType == FastRecordAccessoryViewTypeText ? nil : weakSelf.inputView;
        [weakSelf.textView reloadInputViews];
        if (currentType == FastRecordAccessoryViewTypeText) {
//            [FastRecordVoiceInputViewDim dismiss];
        } else {
//            [FastRecordVoiceInputViewDim showMarginBottom:(_keyboardHeigth)];
        }
//        weakSelf.textView.hidden = currentType == FastRecordAccessoryViewTypeText ? NO : YES;
    };
    _inputAccessory = accessoryView;
    _textView.inputAccessoryView = accessoryView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeigth = CGRectGetHeight(keyboardRect);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (FastRecordVoiceInputView *)inputView {
    if (!_inputView) {
        __weak typeof(self) weakSelf = self;
        FastRecordVoiceInputView *inputView = [FastRecordVoiceInputView instanceFromNib];
        _inputView = inputView;
        _inputView.didCompletedBlock = ^(FastRecordVoiceInputView *view, NSURL *voicePath, NSTimeInterval duration) {
            weakSelf.fastRecordCellModel.recordVoicePath = voicePath;
            weakSelf.fastRecordCellModel.recordVoiceDuration = [NSString stringWithFormat:@"%.f", duration];
            [FastRecordVoiceInputViewDim dismiss];
            [weakSelf fastRecordCellDidCliced:nil];
        };
    }
    
    return _inputView;
}


- (void)setText:(NSString *)text {
    _textView.text = text;
    
    CGFloat height = [_textView sizeThatFits:CGSizeMake(_textView.bounds.size.width, CGFLOAT_MAX)].height;
    _textViewMaxHeight.constant = height+10;
    _textViewContentSizeHeigth = height;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    self.text = item.recordText;
}

#pragma mark - Action
- (IBAction)fastRecordCellDidCliced:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
        [self.delegate fastRecordCell:self didClicked:FastRecordActionTypeVoice atIndexpath:self.indexPath withObject:nil];
    }
}

#pragma mark - <YYTextViewDelegate>
- (BOOL)textViewShouldReturn:(YYTextView *)textView {
    self.fastRecordCellModel.recordText = textView.text;
    if (textView.text.length >= 200) {
        self.fastRecordCellModel.recordText = [textView.text substringToIndex:200];
    }
    [FastRecordVoiceInputViewDim dismiss];
    [textView resignFirstResponder];
    if (_textViewContentSizeHeigth != textView.contentSize.height) {
        _textViewContentSizeHeigth = textView.contentSize.height;
                [[NSNotificationCenter defaultCenter] postNotificationName:FastRecordTextInputCellTextViewDidChangedHeigthNotification object:nil];
    }
    return NO;
}

- (void)textViewDidChange:(YYTextView *)textView {
    self.fastRecordCellModel.recordText = textView.text;
    if (textView.text.length >= 200) {
        [YYHud showTip:@"请将随手记内容保持在200个字以内"];
        NSString *text = [textView.text substringToIndex:200];
        self.fastRecordCellModel.recordText = text;
        textView.text = text;
        return;
    }
    if (_textViewContentSizeHeigth != textView.contentSize.height) {
        _textViewContentSizeHeigth = textView.contentSize.height;
        [[NSNotificationCenter defaultCenter] postNotificationName:FastRecordTextInputCellTextViewDidChangedHeigthNotification object:nil];
        _textViewMaxHeight.constant = _textViewContentSizeHeigth+10;
        NSLog(@"%lf, %@", _textViewContentSizeHeigth, NSStringFromCGRect(textView.bounds));
        CGRect frme = _inputAccessory.bounds;
        frme.size.height = _textViewContentSizeHeigth+10;
        _inputAccessory.bounds = frme;
        
    }
}


@end
