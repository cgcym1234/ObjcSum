//
//  FastRecordCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordCell.h"
#import "FastRecordVoiceButton.h"

#define MarginTop 10

@interface FastRecordCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordTextMarginTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordVoiceMarginTop;;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordVoiceHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordImageMarginTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordImageWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordImageToBottom;

@property (nonatomic, strong) FastRecordVoiceButton *voiceButton;

@end

@implementation FastRecordCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordImageDidClicked:)];
    tap.numberOfTapsRequired = 1;
    _recordImage.userInteractionEnabled = YES;
    [_recordImage addGestureRecognizer:tap];
    
    FastRecordVoiceButton *voiceButton = [FastRecordVoiceButton instanceFromNib];
    voiceButton.showDeleteButton = NO;
    voiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_recordVoiceContainer addSubview:voiceButton];
    
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[voiceButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(voiceButton)];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[voiceButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(voiceButton)];
    [_recordVoiceContainer addConstraints:constraintsH];
    [_recordVoiceContainer addConstraints:constraintsV];
    
    
    _voiceButton = voiceButton;
    _recordVoiceContainer.backgroundColor = [UIColor whiteColor];
    
    _title.layer.cornerRadius = 14;
    _title.layer.masksToBounds = YES;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

#pragma mark - Private
- (void)configLayout {
//    UILayoutPriority recordImageTopToTextPriority = isShowText ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow;
//    UILayoutPriority recordImageTopToVoicePriority = !isShowText ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow;
//    
//    _recordImageTopToText.priority = recordImageTopToTextPriority;
//    _recordImageTopToVoice.priority = recordImageTopToVoicePriority;
//    
//    _recordText.hidden = !isShowText;
    
    _recordTextMarginTop.constant = _recordText.hidden ? 0 : MarginTop;
    
    _recordVoiceMarginTop.constant = _recordVoiceContainer.hidden ? 0 : MarginTop;
    _recordVoiceHeight.constant = _recordVoiceContainer.hidden ? 0 : 34;
    
    _recordImageMarginTop.constant = _recordImage.hidden ? 0 : MarginTop;
    _recordImageWidth.constant = _recordImage.hidden ? 0 : 65;
}

- (void)setRecordImages:(NSArray *)recordImages {
    UIImage *image = recordImages.firstObject;
    _recordImage.image = image;
    _recordImage.hidden = image == nil;
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {

    if (item.recordVoicePath) {
        item.recordText = nil;
    }
    _title.text = item.title;
    _recordDate.text = item.recordDateStr;
    _clockIcon.hidden = item.clockDate == nil;
    
    _recordText.text = item.recordText;
    _recordText.hidden = item.recordText == nil;
    
    [_voiceButton setVoiceWithURL:item.recordVoicePath];
    _voiceButton.text = item.recordVoiceDuration;
    _recordVoiceContainer.hidden = item.recordVoicePath == nil;
    
    [self setRecordImages:item.recordImages];
    [self configLayout];
    
    _indexPath = [indexPath copy];
}

#pragma mark - Action
- (IBAction)deleteIconDidCliced:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(fastRecordCell:didClickedDeleteIconAtIndexpath:)]) {
        [_delegate fastRecordCell:self didClickedDeleteIconAtIndexpath:_indexPath];
    }
}

- (IBAction)recordImageDidClicked:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(fastRecordCell:didClickedRecordImageAtIndexpath:)]) {
        [_delegate fastRecordCell:self didClickedRecordImageAtIndexpath:_indexPath];
    }
}


@end
