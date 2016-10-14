//
//  YYTextViewTimePicker.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYTextViewTimePicker.h"


#define DateFormatDefault @"yyyy-MM-dd HH:mm:ss"

@interface YYTextViewTimePicker ()

@end

@implementation YYTextViewTimePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self envInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self envInit];
}

- (void)envInit {
    self.inputView = self.datePicker;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = DateFormatDefault;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker = datePicker;
    }
    return _datePicker;
}

- (YYInputAccessoryViewWithCancel *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [YYInputAccessoryViewWithCancel instanceFromNib];
        
        __weak typeof(self) weakSelf = self;
        _accessoryView.didClickedBlock = ^(YYInputAccessoryViewWithCancel *view, YYInputAccessoryViewWithCancelType type) {
            if (weakSelf.didClickedAccessoryBlock) {
                weakSelf.didClickedAccessoryBlock(weakSelf, type, weakSelf.datePicker.date);
            }
        };
        self.inputAccessoryView = _accessoryView;
    }
    return _accessoryView;
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    if (_valueChangedBlock) {
        _valueChangedBlock(self, datePicker.date);
    }
}

#pragma mark - Public
- (NSDate *)date {
    return _datePicker.date;
}

- (void)setDate:(NSDate *)date {
    _datePicker.date = date;
}

- (NSString *)dateStr {
    return [_dateFormatter stringFromDate:_datePicker.date];
}

- (void)setDateStr:(NSString *)dateStr {
    NSDate *date = [_dateFormatter dateFromString:dateStr];
    if (date) {
        _datePicker.date = date;
    }
}

- (void)setAccessoryViewShow:(BOOL)accessoryViewShow {
    _accessoryViewShow = accessoryViewShow;
    self.accessoryView.hidden = !_accessoryViewShow;
}
@end
