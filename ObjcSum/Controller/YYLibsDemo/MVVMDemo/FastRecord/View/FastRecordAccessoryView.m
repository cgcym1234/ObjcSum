//
//  FastRecordAccessoryView.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordAccessoryView.h"

#define  FastRecordAccessoryViewTypeTextTitle  @"语音输入"
#define  FastRecordAccessoryViewTypeTextImage  @"fastRecordVoice"

#define  FastRecordAccessoryViewTypeVoiceTitle @"文本输入"
#define  FastRecordAccessoryViewTypeVoiceImage  @"fastRecordEdit"

@interface FastRecordAccessoryView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation FastRecordAccessoryView

- (void)awakeFromNib {
    // Initialization code
    self.currentType = FastRecordAccessoryViewTypeText;
    [_switchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_switchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _switchButton.layer.borderWidth = 1;
    _switchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _switchButton.layer.cornerRadius = 14;
    
    _lineHeight.constant = 0.5;
}



- (IBAction)switchButtonDidClicked:(UIButton *)sender {
    self.currentType = !_currentType;
    if (_didClickedBlock) {
        _didClickedBlock(self, _currentType);
    }
}

#pragma mark - Public
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FastRecordAccessoryView *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FastRecordAccessoryView instanceFromNib];
    });
    return sharedInstance;
}


- (void)setCurrentType:(FastRecordAccessoryViewType)currentType {
    _currentType = currentType;
    NSString *title = currentType == FastRecordAccessoryViewTypeText ? FastRecordAccessoryViewTypeTextTitle : FastRecordAccessoryViewTypeVoiceTitle;
    NSString *imageName = currentType == FastRecordAccessoryViewTypeText ? FastRecordAccessoryViewTypeTextImage : FastRecordAccessoryViewTypeVoiceImage;
    
    [_switchButton setTitle:title forState:UIControlStateNormal];
    [_switchButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
