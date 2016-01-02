//
//  YYMessageTextLabel.m
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageTextLabel.h"

@implementation YYMessageTextLabel

#pragma mark - Public

- (instancetype)cloneLabel {
    YYMessageTextLabel *label = [YYMessageTextLabel new];
    label.font = self.font;
    label.textColor = self.textColor;
    label.numberOfLines = self.numberOfLines;
    return label;
}

@end
