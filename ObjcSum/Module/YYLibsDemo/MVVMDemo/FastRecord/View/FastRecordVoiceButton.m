//
//  FastRecordVoiceButton.m
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import "FastRecordVoiceButton.h"
#import "AFNetworking.h"
#define AMR_MAGIC_NUMBER "#!AMR\n"

@implementation FastRecordVoiceButton

- (void)awakeFromNib {
    _showDeleteButton = YES;
    _voiceButton.layer.borderColor = ColorFromRGBHex(0xdddddd).CGColor;
    _voiceButton.layer.borderWidth = 1;
    _voiceButton.layer.cornerRadius = 16;
}

- (IBAction)voiceButtonDidClicked:(UIButton *)sender {
    if (_didClickedBlock) {
        _didClickedBlock(self, FastRecordVoiceButtonActionTypePlay);
    }
    [self play];
}

- (IBAction)deleteButtonDidClicked:(UIButton *)sender {
    if (self.filePath.absoluteString) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath.absoluteString error:nil];
    }
    
    if (_didClickedBlock) {
        _didClickedBlock(self, FastRecordVoiceButtonActionTypeDelete);
    }
}

#pragma mark - Public
+ (instancetype)instanceFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton {
    _showDeleteButton = showDeleteButton;
    _deleteButton.hidden = !showDeleteButton;
}

- (void)setText:(NSString *)text {
    _text = text;
    [_voiceButton setTitle:text != nil ? [text stringByAppendingString:@"''"] : nil forState:UIControlStateNormal];
}

#pragma mark - outcall
- (void)setVoiceWithURL:(NSURL*)url
{
    self.filePath = url;
}


#pragma mark - event
- (void)play {
    if (!self.filePath) {
        return;
    }
    NSLog(@"play  %@", self.filePath);
//    if ([MLAmrPlayer shareInstance].isPlaying) {
//        [[MLAmrPlayer shareInstance] stopPlaying];
//    } else {
//        [[MLAmrPlayer shareInstance] playWithFilePath:self.filePath];
//    }
    

}
- (void)cancel {
//    [[MLAmrPlayer shareInstance] stopPlaying];
}



@end
