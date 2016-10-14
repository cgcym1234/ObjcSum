//
//  YYAlertGridViewCell.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/22.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertGridViewCell.h"

@implementation YYAlertGridViewCell

- (void)awakeFromNib {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.f].CGColor;
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithWhite:0.62 alpha:0.62];
    self.selectedBackgroundView = bg;
    [self bringSubviewToFront:self.selectedBackgroundView];
}

@end
