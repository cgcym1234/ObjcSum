//
//  YYMessageTextLabel.m
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageTextLabel.h"

@implementation YYMessageTextLabel

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
}

#pragma mark - Public

- (instancetype)clone {
    YYMessageTextLabel *label = [YYMessageTextLabel new];
    label.font = self.font;
    label.textColor = self.textColor;
    label.numberOfLines = self.numberOfLines;
    return label;
}

@end
