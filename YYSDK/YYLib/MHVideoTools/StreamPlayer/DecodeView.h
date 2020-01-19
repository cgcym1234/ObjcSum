//
//  DecodeView.h
//  VTH264examples
//
//  Created by tl on 2018/6/6.
//  Copyright © 2018年 srd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "H264HwDecoderImpl2.h"

@interface DecodeView : UIView

- (void)setupView;

- (void)validatePlayer;
- (void)invalidatePlayer;
- (void)resetAudio;

/// handler在子线程执行
- (void)getSnapshot:(void (^)(UIImage *))handler;
- (void)saveSnapshotToPath:(NSString *)path;

- (void)inputNalu:(uint8_t*)frame
             size:(uint32_t)size
             type:(VideoSteamType)type;

- (void)inputAudio:(uint8_t*)frame size:(uint32_t)size;

@end
