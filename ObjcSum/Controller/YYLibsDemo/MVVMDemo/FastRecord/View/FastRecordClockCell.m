//
//  FastRecordClockCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordClockCell.h"
#import "YYTextViewTimePicker.h"

@interface FastRecordClockCell ()

@property (nonatomic, strong) YYTextViewTimePicker *textViewTimePicker;
@end

@implementation FastRecordClockCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imageButton.tag = FastRecordActionTypeImage;
    _clockButton.tag = FastRecordActionTypeClock;
}

- (YYTextViewTimePicker *)textViewTimePicker {
    if (!_textViewTimePicker) {
        __weak typeof(self)weakSelf = self;
        YYTextViewTimePicker *textViewTimePicker = [[YYTextViewTimePicker alloc] init];
        textViewTimePicker.accessoryViewShow = YES;
        textViewTimePicker.didClickedAccessoryBlock = ^(YYTextViewTimePicker *view, NSInteger index, NSDate *date) {
            if (index == YYInputAccessoryViewWithCancelTypeDone) {
                weakSelf.fastRecordCellModel.clockDate = date;
                weakSelf.text = weakSelf.fastRecordCellModel.clockDateStr;
            }
            
            [view resignFirstResponder];
        };
        [self.contentView addSubview:textViewTimePicker];
        _textViewTimePicker = textViewTimePicker;
    }
    return _textViewTimePicker;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setText:(NSString *)text {
    _text = text;
    _clockLabel.text = text;
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    self.text = item.clockDateStr;
//    _imageButton.hidden = item.recordImages.count > 0;
}


#pragma mark - Action
- (IBAction)fastRecordCellDidCliced:(UIButton *)sender {
    if (sender.tag == FastRecordActionTypeClock) {
        [self.textViewTimePicker becomeFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
        [self.delegate fastRecordCell:self didClicked:sender.tag atIndexpath:self.indexPath withObject:nil];
    }
}

@end
