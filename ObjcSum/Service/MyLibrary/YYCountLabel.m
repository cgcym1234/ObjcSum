//
//  YYCountLabel.m
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import "YYCountLabel.h"
#import "UIView+YYMessage.h"

@implementation YYCountLabel


+ (instancetype)newInstance {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    [self setToRounded];
}

- (void)setCurrent:(NSInteger)current total:(NSInteger)total {
    self.total = total;
    self.current = current;
}

- (void)setCurrent:(NSInteger)current {
    if (_current != current) {
        _current = current;
        NSInteger showPage = MIN(_total, (current+1));
        NSString *str = [NSString stringWithFormat:@"%li/%li", showPage, (long)_total];
        
        NSRange range = [str rangeOfString:@"/"];
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr setAttributes:attr range:NSMakeRange(0, range.location)];
        self.attributedText = attrStr;
    }
}

- (void)setTotal:(NSInteger)total {
    if (_total != total) {
        _total = total;
        NSInteger showPage = MIN(_total, (_current+1));
        NSString *str = [NSString stringWithFormat:@"%li/%li", showPage, (long)_total];
        
        NSRange range = [str rangeOfString:@"/"];
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr setAttributes:attr range:NSMakeRange(0, range.location)];
        self.attributedText = attrStr;
    }
}


@end
