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
//    self.backgroundColor= [UIColor redColor];
}

//- (UIEdgeInsets)alignmentRectInsets {
//    return UIEdgeInsetsMake(10, 10, 10, 20);
//}

#pragma mark - Public

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
