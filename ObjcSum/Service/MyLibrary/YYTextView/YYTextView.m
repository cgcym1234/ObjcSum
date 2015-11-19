//
//  YYTextView.m
//  MLLCustomer
//
//  Created by sihuan on 15/4/28.
//  Copyright (c) 2015年 Meilele. All rights reserved.
//

#import "YYTextView.h"

#define LabelFontDefault   [UIFont systemFontOfSize:14]
#define LabelColorDefault  [UIColor lightGrayColor]

#define PaddingPlaceHolder 8
#define PaddingCharNum 12

#define HeightCharNumLabel 10

@interface YYTextView ()<UITextViewDelegate>

@end

@implementation YYTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self envInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self envInit];
}

- (void)envInit {
    self.delegate = self;
    [self addSubview:self.placeHolderLabel];
}

- (void)layoutSubviews {
    CGFloat width = CGRectGetWidth(self.bounds) - 1 * PaddingPlaceHolder;
    CGFloat height = CGRectGetHeight(self.bounds) - 1 * PaddingPlaceHolder;
    CGSize size = [_placeHolderLabel sizeThatFits:CGSizeMake(width, height)];
    _placeHolderLabel.frame = CGRectMake(PaddingPlaceHolder, PaddingPlaceHolder, size.width, size.height);
    
    _maxcharNumLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - HeightCharNumLabel - PaddingCharNum, CGRectGetWidth(self.bounds) - PaddingCharNum, HeightCharNumLabel);
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = LabelFontDefault;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = LabelColorDefault;
        
        _placeHolderLabel = label;
        
    }
    return _placeHolderLabel;
}

- (UILabel *)maxcharNumLabel {
    if (!_maxcharNumLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = LabelFontDefault;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = LabelColorDefault;
        label.frame = self.bounds;
        
        [self addSubview:label];
        _maxcharNumLabel = label;
        
    }
    return _maxcharNumLabel;
}

- (YYInputAccessoryViewWithCancel *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [YYInputAccessoryViewWithCancel instanceFromNib];
        
        __weak typeof(self) weakSelf = self;
        _accessoryView.didClickedBlock = ^(YYInputAccessoryViewWithCancel *view, YYInputAccessoryViewWithCancelType type) {
            if (weakSelf.didClickedAccessoryBlock) {
                weakSelf.didClickedAccessoryBlock(weakSelf, type, weakSelf.text);
            }
        };
        
        self.inputAccessoryView = _accessoryView;
    }
    return _accessoryView;
}

#pragma mark - Public
- (void)setPlaceHolder:(NSString *)placeHolder {
    self.placeHolderLabel.text = placeHolder;
}

- (void)setMaxCharNumShow:(BOOL)maxCharNumShow {
    _maxCharNumShow = maxCharNumShow;
    self.maxcharNumLabel.hidden = !maxCharNumShow;
}

- (void)setMaxCharNum:(NSUInteger)maxCharNum {
    _maxCharNum = maxCharNum;
    
    self.maxcharNumLabel.text = _maxCharNum > 0 ? [NSString stringWithFormat:@"0/%ld", (unsigned long)_maxCharNum] : nil;
}

- (void)setAccessoryViewShow:(BOOL)accessoryViewShow {
    _accessoryViewShow = accessoryViewShow;
    self.accessoryView.hidden = !_accessoryViewShow;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length > 0) {
        self.placeHolderLabel.hidden=YES;
    }
    else{
        self.placeHolderLabel.hidden=NO;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL ret = YES;
    if([_yyDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
    {
        ret = [_yyDelegate textViewShouldBeginEditing:self];
    }
    return ret;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    BOOL ret = YES;
    if([_yyDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
    {
        ret = [_yyDelegate textViewShouldBeginEditing:self];
    }
    return ret;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([_yyDelegate respondsToSelector:@selector(textViewDidBeginEditing:)])
    {
        [_yyDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([_yyDelegate respondsToSelector:@selector(textViewDidEndEditing:)])
    {
        [_yyDelegate textViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL ret = YES;
    
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        if([_yyDelegate respondsToSelector:@selector(textViewShouldReturn:)])
        {
            ret = [_yyDelegate textViewShouldReturn:self];
        }
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
//    if(_maxCharNum > 0)
//    {
//        NSString* orginalText = textView.text;
//        NSInteger length = [orginalText length] - range.length + [text length];
//        if(length <= _maxCharNum)
//        {
//            return YES;
//        }
//        return NO;
//    }
    return ret;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_maxCharNum > 0 && textView.text.length > _maxCharNum) {
        textView.text = [textView.text substringToIndex:_maxCharNum];
        return;
    }

    if (self.text.length > 0) {
        self.placeHolderLabel.hidden=YES;
    }
    else{
        self.placeHolderLabel.hidden=NO;
    }
    
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    
    if ( overflow > 0 ) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7;
        [textView setContentOffset:offset];
    }
    
    if (_maxCharNum > 0) {
        _maxcharNumLabel.text = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)textView.text.length, _maxCharNum];
    }
    
    
    if([_yyDelegate respondsToSelector:@selector(textViewDidChange:)])
    {
        [_yyDelegate textViewDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if([_yyDelegate respondsToSelector:@selector(textViewDidChangeSelection:)])
    {
        [_yyDelegate textViewDidChangeSelection:self];
    }
}

@end
