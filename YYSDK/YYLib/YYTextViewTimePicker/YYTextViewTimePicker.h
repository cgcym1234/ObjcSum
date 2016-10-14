//
//  YYTextViewTimePicker.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInputAccessoryViewWithCancel.h"


#pragma mark - 时间选择的UITextView

@class YYTextViewTimePicker;

typedef void (^YYTextViewTimePickerValueChangedBlock)(YYTextViewTimePicker *view, NSDate *date);

//左箭头，右键头，完成，按钮索引是 0 1 2
typedef void (^YYTextViewTimePickerDidClickedAccessoryBlock)(YYTextViewTimePicker *view, NSInteger index, NSDate *date);

@interface YYTextViewTimePicker : UITextView

@property (nonatomic, strong) UIDatePicker *datePicker;

//default is "yyyy-MM-dd HH:mm:ss"
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, copy) YYTextViewTimePickerValueChangedBlock valueChangedBlock;

//在键盘上加一个辅助条
@property (nonatomic, strong) YYInputAccessoryViewWithCancel *accessoryView;
//是否显示辅助条，默认不显示
@property (nonatomic,assign) BOOL accessoryViewShow;

@property (nonatomic, copy) YYTextViewTimePickerDidClickedAccessoryBlock didClickedAccessoryBlock;

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDate *date;

@end
