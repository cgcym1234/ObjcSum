//
//  UIButton+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/4/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "UIButton+YYMessage.h"

#pragma mark  Keys

static NSString * const ImageInput = @"ChatWindow_Keyboard";
static NSString * const ImageVoice = @"ChatWindow_Speaking";
static NSString * const ImageEmoji = @"ChatWindow_Expression";
static NSString * const ImageMore = @"ChatWindow_More";

@implementation UIButton (YYMessage)

- (void)setImageNomalState:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setImageInput {
    [self setImageNomalState:[UIImage imageNamed:ImageInput]];
}
- (void)setImageVoice {
    [self setImageNomalState:[UIImage imageNamed:ImageVoice]];
}
- (void)setImageEmoji {
    [self setImageNomalState:[UIImage imageNamed:ImageEmoji]];
}
- (void)setImageMore {
    [self setImageNomalState:[UIImage imageNamed:ImageMore]];
}

@end
