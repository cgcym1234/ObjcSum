//
//  YYInputAccessoryViewWithCancel.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/10/8.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "YYInputAccessoryViewWithCancel.h"

@implementation YYInputAccessoryViewWithCancel

- (void)awakeFromNib {
    _cancelButton.tag = YYInputAccessoryViewWithCancelTypeCancel;
    _doneButton.tag = YYInputAccessoryViewWithCancelTypeDone;
    
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1].CGColor;
}

- (IBAction)didClickedButton:(UIButton *)sender {
    if (_didClickedBlock) {
        _didClickedBlock(self, sender.tag);
    }
}


#pragma mark - Public
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


@end
