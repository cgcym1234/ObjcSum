//
//  YYNoDataView.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/18.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYNoDataView.h"

@interface YYNoDataView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stringLabelTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopMargin;

@end

@implementation YYNoDataView

#define YYBgColor [UIColor colorWithWhite:1 alpha:1]
#define YYLabelDefault @"很抱歉，暂时没有数据，请稍候再试!"
#define YYImageDefault @"no_data_default"

- (instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].firstObject;
    self.backgroundColor = YYBgColor;
    return self;
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
}

- (void)update:(NSString *)content
         image:(UIImage *)image
   buttonTitle:(NSString *)buttonTitle
   buttonBlock:(void(^)())buttonBlock {
    _stringLabel.text = content;
    _imageView.image = image;
    [_button setTitle:buttonTitle forState:UIControlStateNormal];
    _buttonBlock = buttonBlock;
    
    _imageViewHeight.constant = image != nil ? 120 : 0;
    _stringLabelTopMargin.constant = content != nil ? 6 : 0;
    _buttonHeight.constant = buttonTitle != nil ? 32 : 0;
    _buttonTopMargin.constant = buttonTitle != nil ? 8 : 0;
}

- (IBAction)didClickedButton:(UIButton *)sender {
    if (_buttonBlock) {
        _buttonBlock();
    }
}

#pragma mark - Pulic

- (void)update:(NSString *)content image:(UIImage *)image {
    return [self update:content image:image buttonTitle:nil buttonBlock:nil];
}

+ (YYNoDataView *)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image {
    return [[[YYNoDataView alloc] init] showInView:superView content:content image:image];
}

- (YYNoDataView *)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image {
    return [self showInView:superView content:content image:image buttonTitle:nil buttonBlock:nil];
}

- (YYNoDataView *)showInView:(UIView *)superView
                     content:(NSString *)content
                       image:(UIImage *)image
                 buttonTitle:(NSString *)buttonTitle
                 buttonBlock:(void(^)())buttonBlock {
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    [self update:content image:image buttonTitle:buttonTitle buttonBlock:buttonBlock];
    [superView addSubview:self];
    return self;
}

@end
