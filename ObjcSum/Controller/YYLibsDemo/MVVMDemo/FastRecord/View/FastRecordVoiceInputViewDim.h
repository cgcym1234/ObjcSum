//
//  FastRecordVoiceInputViewDim.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastRecordVoiceInputViewDim : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) NSString *text;

+ (instancetype)shareInstance;

/*
 显示在距离屏幕底部多少之上
 */
+ (instancetype)showMarginBottom:(CGFloat)marginBottom;

+ (void)dismiss;

@end
