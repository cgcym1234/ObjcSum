//
//  DecodeView.m
//  VTH264examples
//
//  Created by tl on 2018/6/6.
//  Copyright © 2018年 srd. All rights reserved.
//

#import "DecodeView.h"
#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface DecodeView ()<H264HwDecoderImplDelegate>

@property (nonatomic,strong) H264HwDecoderImpl2 *decoder;
@property (nonatomic,strong) AVSampleBufferDisplayLayer *glLayer;
@property(strong, nonatomic) AudioPlayer *audioPlayer;

@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic,assign) BOOL canPlay;

@end

@implementation DecodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [_decoder closed];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _glLayer.frame = self.bounds;
    _glLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _videoSize = self.bounds.size;
}

- (void)setupView {
    //    if (!_decoder) {
    //        _decoder = [[H264HwDecoderImpl3 alloc] init];
    //    }
    //
    //    _decoder.delegate = self;
    if (!_glLayer) {
        _glLayer = [AVSampleBufferDisplayLayer new];
    }
    
    _glLayer.frame = self.bounds;
    _glLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _glLayer.videoGravity = AVLayerVideoGravityResize;
    _glLayer.opaque = YES;
    _canPlay = YES;
    
    _videoSize = self.bounds.size;
    if (self.glLayer.superlayer == nil) {
        [self.layer addSublayer:self.glLayer];
    }
}

- (void)validatePlayer {
    _canPlay = YES;
    
    if (!_glLayer) {
        [self setupView];
    }
}

- (void)invalidatePlayer {
    self.canPlay = NO;
    [self.glLayer removeFromSuperlayer];
    self.glLayer = nil;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        self.canPlay = NO;
//        [self.glLayer removeFromSuperlayer];
//        self.glLayer = nil;
//    }];
}

- (void)resetAudio {
    _audioPlayer = nil;
}

- (void)inputNalu:(uint8_t*)frame
             size:(uint32_t)size
             type:(VideoSteamType)type {
    if (type == VideoSteamType_Audio) {
        [self.audioPlayer fillBuffer:frame size:size];
        return;
    }
    
    if (!_decoder) {
        _decoder = [[H264HwDecoderImpl2 alloc] initWithType:type size:_videoSize];
        _decoder.delegate = self;
    }
    
    if (!_canPlay) {
        //        free(buffer);
    }else {
        [_decoder decodeNalu:frame withSize:size];
    }
}

- (void)inputAudio:(uint8_t*)frame
              size:(uint32_t)size {
    [self.audioPlayer fillBuffer:frame size:size];
}

- (void)getSnapshot:(void (^)(UIImage *))handler {
    [_decoder getSnapshot:handler];
}

- (void)saveSnapshotToPath:(NSString *)path {
    [_decoder saveImageToPath:path];
}


#pragma mark -  H264解码回调  H264HwDecoderImplDelegate delegare
- (void)displayDecodedFrame:(CMSampleBufferRef)imageBuffer {
    if(imageBuffer) {
        if ([_glLayer isReadyForMoreMediaData]) {
            //            [NSThread sleepForTimeInterval:0.067 ];
            //                        NSLog(@"thread is %@",[NSThread currentThread]);
            __weak typeof(self) weakSelf = self;
            if (!_canPlay) {
                CFRelease(imageBuffer);
                return;
            }
            
            dispatch_sync(dispatch_get_main_queue(),^{
                if (self.glLayer.superlayer == nil) {
                    [self.layer addSublayer:weakSelf.glLayer];
                }
            });
            
            [weakSelf.glLayer enqueueSampleBuffer:imageBuffer];
            if (weakSelf.glLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
                [weakSelf.glLayer flush];
            }
        }
        CFRelease(imageBuffer);
    }
}

#pragma mark - Getter
- (AudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [AudioPlayer new];
    }
    
    return _audioPlayer;
}

- (H264HwDecoderImpl2 *)decoder {
    if (!_decoder) {
        _decoder = [[H264HwDecoderImpl2 alloc] initWithType:VideoSteamType_H265 size:_videoSize];
        _decoder.delegate = self;
    }
    
    return _decoder;
}

@end
