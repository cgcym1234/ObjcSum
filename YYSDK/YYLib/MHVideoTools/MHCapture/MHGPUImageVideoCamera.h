//
//  MHGPUImageVideoCamera.h
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/20.
//  Copyright © 2019 mh. All rights reserved.
//

#import "GPUImageVideoCameraEx.h"

@protocol MHGPUImageVideoCameraDelegate <NSObject>

@optional
-(void)processAudioSample:(CMSampleBufferRef)sampleBuffer;

@end

@interface MHGPUImageVideoCamera : GPUImageVideoCameraEx

@property (nonatomic, weak) id<MHGPUImageVideoCameraDelegate> mhAudioDelegate;

-(void)setCaptureSessionPreset:(NSString *)captureSessionPreset;

@end





@protocol MHGPUImageCaptureDataDelegate <NSObject>

@optional
//输出音视频数据
-(void)gpuImageSendAudioSample:(CMSampleBufferRef)sampleBuffer;
-(void)gpuImageSendVideoBuffer:(CVImageBufferRef)videoBuffer;

@end


@interface MHGPUImageAVCaptureDataHandler : GPUImageRawDataOutput< MHGPUImageVideoCameraDelegate>

@property(nonatomic,weak)id<MHGPUImageCaptureDataDelegate> mhGPUOutDelegate;
@property(nonatomic,assign)BOOL isCapture;

- (instancetype)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat isCapture:(BOOL)isCapture;

@end
