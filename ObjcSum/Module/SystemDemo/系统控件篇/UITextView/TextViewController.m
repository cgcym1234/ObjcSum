//
//  TextViewController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/2.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()
<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
}

#pragma mark - UITextView
/*
 
 */
- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        //设置大小位置
        textView.frame=CGRectMake(10, 30, 300, 100);
        //设置背景颜色
        textView.backgroundColor=[UIColor orangeColor];
        //设置文字内容
        textView.text=@"what should i say to u,my lovely world,hello,anybody home.我是小坏蛋，你们有谁知道吗？我不知道该输入什么了啊！还要继续输入吗？真得吗？hello,aggin,here am i.what are you doing,man?where are u going man?";
        //设置字体大小，加粗和斜体等
        textView.font=[UIFont boldSystemFontOfSize:18];
        
        //经过以上设置，文字超过框，我们可以上下滚动来查看，而且我们也能继续输入添加删除等等，还可以copy和cut（双击文字）
        //还可以换行输入等等，这是和textField的区别之一
        //如果是否可编辑设置为NO，则不可添加删除和cut，只能copy
        //这个时候键盘也不出来了，只能双击文字copy
        //textView.editable = NO;
        
        textView.delegate = self;
        
        _textView = textView;
        
    }
    return _textView;
}




#pragma mark - UITextViewDelegate
//以下四个协议里面的方式和UITextFieldDelegate里地一样，略去不说
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
//- (void)textViewDidBeginEditing:(UITextView *)textView;
//- (void)textViewDidEndEditing:(UITextView *)textView;

//一看是BOOL，不是YES就是NO，就是允许修改内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    #pragma mark - 禁止输入 emoji 表情
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - iOS7光标问题
//只有在内容改变时才触发，而且这个改变内容是手动输入有效，用本例中得按钮增加内容不触发这个操作
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"Did Change");
    
    
    
    /*
     PS：有网友遇到textView在ios7上出现编辑进入最后一行时光标消失，看不到最后一行，变成盲打，
     stackOverFlow网站上有大神指出，是ios7本身bug，加上下面一段代码即可（网友调试得出，在此mark一下，有问题，欢迎大神们指出）
     */
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [textView setContentOffset:offset];
    }
}

//几乎所有操作都会触发textViewDidChangeSelection，包括点击文本框、增加内容删除内容
//可以理解为只要于selectedRange有关都会触发，（位置与长度）
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"Did Change Selection");
}


#pragma mark - emoji 表情相关
// 过滤所有表情  https://gist.github.com/cihancimen/4146056
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (void)buttonAction:(id)sender
{
    if ([self stringContainsEmoji:self.textView.text]) {
        
        NSString *str = [self disable_emoji:self.textView.text];
        NSLog(@"%lu", (unsigned long)str.length);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未检测到Emoji表情" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


@end
