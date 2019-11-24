//
//  MHGPUImageVideoCamera.m
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/20.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHGPUImageVideoCamera.h"
#import "MHCVPixelBuffer.h"

@implementation MHGPUImageVideoCamera

-(void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    [super processAudioSampleBuffer:sampleBuffer];
    [self.mhAudioDelegate processAudioSample:sampleBuffer];
}

-(void)setCaptureSessionPreset:(NSString *)captureSessionPreset{
    if (!_captureSession || ![_captureSession canSetSessionPreset:captureSessionPreset]) {
        @throw [NSException exceptionWithName:@"Not supported captureSessionPreset" reason:[NSString stringWithFormat:@"captureSessionPreset is [%@]", captureSessionPreset] userInfo:nil];
        return;
    }
    [super setCaptureSessionPreset:captureSessionPreset];
}


@end




@implementation MHGPUImageAVCaptureDataHandler

- (instancetype)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat isCapture:(BOOL)isCapture
{
    self = [super initWithImageSize:newImageSize resultsInBGRAFormat:resultsInBGRAFormat];
    if (self) {
        self.isCapture = isCapture;
    }
    return self;
}

-(void)processAudioSample:(CMSampleBufferRef)sampleBuffer{
    if(!self.isCapture){
        return;
    }
    if (self.mhGPUOutDelegate && [self.mhGPUOutDelegate respondsToSelector:@selector(gpuImageSendAudioSample:)]) {
        [self.mhGPUOutDelegate gpuImageSendAudioSample:sampleBuffer];
    }
    CFRelease(sampleBuffer);
}

-(void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex{
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
    if(!self.isCapture){
        return;
    }
    [self lockFramebufferForReading];
    // 这里就可以获取到添加滤镜的数据了
    GLubyte *outputBytes = [self rawBytesForImage];
    NSInteger bytesPerRow = [self bytesPerRowInOutput];
    CVPixelBufferRef pixelBuffer = NULL;
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, 640, 480, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
    [self unlockFramebufferAfterReading];

    if (self.mhGPUOutDelegate && [self.mhGPUOutDelegate respondsToSelector:@selector(gpuImageSendVideoBuffer:)]) {
        //32BGRA转Y_UV
        pixelBuffer = [MHCVPixelBuffer convertBufferToY_UV:pixelBuffer];
        [self.mhGPUOutDelegate gpuImageSendVideoBuffer:pixelBuffer];
    }
    CFRelease(pixelBuffer);
    /*
    //将bgra转为yuv
    //图像宽度
    int width = (int)imageSize.width;
    //图像高度
    int height = (int)imageSize.height;
    //宽*高
    int w_x_h = width * height;
    //yuv数据长度 = (宽 * 高) * 3 / 2
    int yuv_len = w_x_h * 3 / 2;

    //yuv数据
    uint8_t *yuv_bytes = malloc(yuv_len);

    //ARGBToNV12这个函数是libyuv这个第三方库提供的一个将bgra图片转为yuv420格式的一个函数。
    //libyuv是google提供的高性能的图片转码操作。支持大量关于图片的各种高效操作，是视频推流不可缺少的重要组件，你值得拥有。
    [self lockFramebufferForReading];
    ARGBToNV12(self.rawBytesForImage, width * 4, yuv_bytes, width, yuv_bytes + w_x_h, width, width, height);
    [self unlockFramebufferAfterReading];

    NSData *yuvData = [NSData dataWithBytesNoCopy:yuv_bytes length:yuv_len];
    if (self.mhGPUOutDelegate && [self.mhGPUOutDelegate respondsToSelector:@selector(gpuImageSendVideoy_uvData:width:height:)]) {
        [self.mhGPUOutDelegate gpuImageSendVideoy_uvData:yuvData width:width height:height];
    }
     */
}

@end
