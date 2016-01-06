//
//  YYMessageAvatarView.m
//  ObjcSum
//
//  Created by sihuan on 16/1/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageAvatarView.h"
#import "UIView+YYMessage.h"

@implementation YYMessageAvatarView

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setContext];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}

- (void)setContext {
    [self addTarget:self action:@selector(touchUpInsideCallback:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public

- (void)setRound:(BOOL)round {
    self.layer.masksToBounds = round;
    self.layer.cornerRadius = self.width/2;
}

- (void)setImage:(UIImage *)image {
    [self setImage:image placeholderImage:nil];
}

- (void)setImage:(UIImage *)image placeholderImage:(UIImage *)placeholder {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setImageUrlSting:(NSString *)urlString {
    
}

#pragma mark - Private

- (void)touchUpInsideCallback:(UIButton *)button {
    if (_touchUpInsideBlock) {
        _touchUpInsideBlock(self);
    }
}

@end
