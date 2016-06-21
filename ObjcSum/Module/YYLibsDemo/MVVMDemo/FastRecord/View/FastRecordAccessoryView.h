//
//  FastRecordAccessoryView.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/30.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

//当前显示状态，文本或语音
typedef NS_ENUM(NSUInteger, FastRecordAccessoryViewType) {
    FastRecordAccessoryViewTypeText = 0,    //当前是文字输入
    FastRecordAccessoryViewTypeVoice,       //当前是语音输入
};

@class FastRecordAccessoryView;

typedef void (^FastRecordAccessoryViewDidClickedBlock)(FastRecordAccessoryView *view, FastRecordAccessoryViewType currentType);


@interface FastRecordAccessoryView : UIView

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

//默认当前是文字
@property (nonatomic, assign) FastRecordAccessoryViewType currentType;
@property (nonatomic, copy) FastRecordAccessoryViewDidClickedBlock didClickedBlock;


+ (instancetype)instanceFromNib;

@end
