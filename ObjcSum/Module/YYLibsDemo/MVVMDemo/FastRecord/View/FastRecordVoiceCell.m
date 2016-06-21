//
//  FastRecordVoiceCell.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordVoiceCell.h"
#import "FastRecordVoiceButton.h"

@interface FastRecordVoiceCell ()

@property (nonatomic, strong) FastRecordVoiceButton *voiceButton;

@end

@implementation FastRecordVoiceCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    FastRecordVoiceButton *voiceButton = [FastRecordVoiceButton instanceFromNib];
    voiceButton.showDeleteButton = YES;
    voiceButton.text = @"4''";
    voiceButton.didClickedBlock = ^(FastRecordVoiceButton *btn, FastRecordVoiceButtonActionType type){
        if (type == FastRecordVoiceButtonActionTypeDelete) {
            weakSelf.fastRecordCellModel.recordVoicePath = nil;
            [weakSelf fastRecordCellDidCliced:btn.deleteButton];
        }
    };
    _voiceButton = voiceButton;
    [_voiceContainer addSubview:voiceButton];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
}

#pragma mark - Public
- (void)updateUI:(FastRecordCellModel *)item atIndexpath:(NSIndexPath *)indexPath {
    [super updateUI:item atIndexpath:indexPath];
    self.voicePath = item.recordVoicePath;
    self.voiceDuration = item.recordVoiceDuration;
}

- (void)setVoicePath:(NSURL *)voicePath {
    _voicePath = voicePath;
    [_voiceButton setVoiceWithURL:voicePath];
}

- (void)setVoiceDuration:(NSString *)voiceDuration {
    _voiceDuration = voiceDuration;
    _voiceButton.text = voiceDuration;
}

#pragma mark - Action
- (IBAction)fastRecordCellDidCliced:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fastRecordCell:didClicked:atIndexpath:withObject:)]) {
        [self.delegate fastRecordCell:self didClicked:FastRecordActionTypeVoice atIndexpath:self.indexPath withObject:nil];
    }
}

@end
