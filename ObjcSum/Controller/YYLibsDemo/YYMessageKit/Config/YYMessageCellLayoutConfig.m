//
//  YYMessageCellLayoutConfig.m
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYMessageCellLayoutConfig.h"

@implementation YYMessageCellConfig

- (instancetype)init {
    if (self = [super init]) {
        
        _messageTextLabel = [YYMessageTextLabel new];
        _messageTextLabel.numberOfLines = 0;
        
        self.cellTopLabelHeight = 20;
        self.bubbleTopLabelHeight = 20;
        self.cellBottomLabelHeight = 20;
        
        self.bubbleArrowWith = 10;
        self.avatarImageViewWH = 40;
        
        self.cellTopLabelFont = [UIFont systemFontOfSize:13];
        self.bubbleTopLabelFont = [UIFont systemFontOfSize:14];
        self.cellBottomLabelFont = [UIFont systemFontOfSize:14];
        self.messageTextLabelFont = [UIFont boldSystemFontOfSize:17];
        
        self.cellTopLabelColor = YYColorFromRGBHex(0x666666);
        self.bubbleTopLabelColor = [UIColor lightGrayColor];
        self.cellBottomLabelColor = [UIColor lightGrayColor];
        
        self.messageTextColorIncoming = [UIColor blackColor];
        self.messageTextColorOutgoing = [UIColor whiteColor];
        
        self.bubbleColorIncoming = [UIColor whiteColor];
        self.bubbleColorOutgoing = YYColorFromRGBHex(0xfa882a);
        
        self.messageBackgroundColor = YYColorFromRGBHex(0xe5e5e5);
        
        self.avatarImageViewShowAtTop = YES;
        self.bubbleTopLabelShow = NO;
        self.cellBottomLabelShow = NO;
        
        self.contentViewInsets = UIEdgeInsetsMake(8, 12, 8, 12);
        self.bubbleViewInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return self;
}

- (void)setMessageTextLabelColor:(UIColor *)messageTextLabelColor {
    _messageTextLabel.textColor = messageTextLabelColor;
}
- (UIColor *)messageTextLabelColor {
    return _messageTextLabel.textColor;
}

- (void)setMessageTextLabelFont:(UIFont *)messageTextLabelFont {
    _messageTextLabel.font = messageTextLabelFont;
}
- (UIFont *)messageTextLabelFont {
    return _messageTextLabel.font;
}

- (void)setAvatarImageViewShowAtTop:(BOOL)avatarImageViewShowAtTop {
    _avatarImageViewShowAtTop = avatarImageViewShowAtTop;
    _bubbleTopLabelShow = avatarImageViewShowAtTop;
    _cellBottomLabelShow = !avatarImageViewShowAtTop;
}

#pragma mark - Public

+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)config:(void (^)(YYMessageCellConfig *))cofig {
    cofig([self defaultConfig]);
}


@end
