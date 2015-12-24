//
//  YYAlertTextView.m
//  justice
//
//  Created by sihuan on 15/10/18.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import "YYAlertTextView.h"
#import "YYDim.h"

@interface YYAlertTextView ()<YYTextViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *line1;
@property (nonatomic, weak) IBOutlet UIView *line2;
@property (nonatomic, weak) IBOutlet UIView *line3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterY;

@end

@implementation YYAlertTextView

- (void)awakeFromNib {
    _cancelButton.tag = 0;
    _confirmButton.tag = 1;
    _line1Height.constant = 0.5;
    _line2Height.constant = 0.5;
    _line3Width.constant = 0.5;
    _textView.yyDelegate = self;
    self.text = nil;
    self.backgroundColor = [UIColor clearColor];
    
    // UIKeyboard Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
}

+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (IBAction)didClicedButton:(UIButton *)sender {
    if (_didClickedBlock) {
        _didClickedBlock(self, sender.tag);
    }
    [YYDim dismss];
}


- (void)textViewDidChange:(YYTextView *)textView {
    _text = textView.text;
}

- (BOOL)textViewShouldReturn:(YYTextView *)textView {
//    [textView resignFirstResponder];
    [self didClicedButton:_confirmButton];
    return NO;
}

#pragma mark - notifycation

- (void)keyboardWillShow:(NSNotification*)notification{
    /**
     *  4,5,keyboardRect = (origin = (x = 0, y = 227), size = (width = 320, height = 253))
     6的height = 258
     */
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat visibleY = CGRectGetMaxY(_containerView.frame);
    CGFloat differ = visibleY - (CGRectGetHeight(self.bounds) - CGRectGetHeight(keyboardRect));
    
    if (differ > 0) {
        _containerViewCenterY.constant = -differ;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    _containerViewCenterY.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}


#pragma mark - Public

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    _textView.placeHolder = placeHolder;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textView.text = text;
}

- (instancetype)show {
    [YYDim showView:self];
    return self;
}

+ (instancetype)show {
    YYAlertTextView *alertView = [YYAlertTextView instanceFromNib];
    return [alertView show];
}

@end
