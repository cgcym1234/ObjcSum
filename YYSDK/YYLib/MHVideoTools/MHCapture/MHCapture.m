//
//  MHCapture.m
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/20.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHCapture.h"
#import "MHBufferTools.h"


@interface MHCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,MHGPUImageCaptureDataDelegate>

//系统类型采集
/** 采集会话 */
@property (nonatomic, strong) AVCaptureSession *captureSession;
/** 采集输入设备 也就是摄像头 */
@property (nonatomic, strong) AVCaptureDeviceInput * videoInputDevice;
/** 音频输入设备 */
@property (nonatomic, strong) AVCaptureDeviceInput * audioInputDevice;
/** 采集输出-视频 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
/** 采集输出-音频 */
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
/** 预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//GPUImage采集
@property (nonatomic, strong) MHGPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) FSKGPUImageBeautyFilter *beautifyFilter;
@property (nonatomic, strong) MHGPUImageAVCaptureDataHandler *dataHandler;
@end

@implementation MHCapture

#pragma mark - 初始化
-(instancetype)initWithCaptureType:(MHAVCaptureType)captureType sessionPreset:(AVCaptureSessionPreset)sessionPreset preViewRect:(CGRect)preViewRect
{
    self = [super init];
    if (self) {
        _captureType = captureType;
        _sessionPreset = sessionPreset;
        _minFrameRate = 30;//默认帧率30
        _preViewRect = preViewRect;
        _preview = [[UIView alloc] initWithFrame:self.preViewRect];
        _preview.backgroundColor = [UIColor blackColor];
        
        if (captureType == MHAVCaptureTypeSystem) {
            //初始化系统摄像头
            [self initSystemCapture];
        }else if (captureType == MHAVCaptureTypeGPUImage) {
            //初始化GPUImage摄像头
            [self initGPUImageCamare];
        }
    }
    return self;
}
#pragma mark - ------------------系统摄像头采集----------------
#pragma mark - 初始化系统摄像头
-(void)initSystemCapture
{
    BOOL success = [self createCaptureDevice];
    if (!success) {
        NSLog(@"初始化摄像头失败!!");
        return;
    }
    [self creatCaptureOutPut];
    [self creatCaptureSession];
    [self createPreviewLayer];
    [self changeFrameRate:self.minFrameRate];
}
#pragma mark - 初始化系统设备
-(BOOL)createCaptureDevice
{
    //获得摄像头输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得前置摄像头
    if (!captureDevice) {
        NSLog(@"取得摄像头时出现问题.");
        return NO;
    }
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    self.videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得摄像头输入对象时出错，错误原因：%@",error.localizedDescription);
        return NO;
    }
    //麦克风
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    self.audioInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"取得麦克风输入对象时出错，错误原因：%@",error.localizedDescription);
    }
    return YES;
}
#pragma mark - 初始化视频输出
-(void)creatCaptureOutPut
{
    dispatch_queue_t captureQueue = dispatch_queue_create("mh.capture.queue", DISPATCH_QUEUE_SERIAL);
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.videoDataOutput setSampleBufferDelegate:self queue:captureQueue];
    [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [self.videoDataOutput setVideoSettings:@{
                                             (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
                                             }];
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:captureQueue];
}
#pragma mark - 初始化_创建会话
-(void)creatCaptureSession
{
    self.captureSession = [AVCaptureSession new];
    [self.captureSession beginConfiguration];
    
    //添加设备
    if ([self.captureSession canAddInput:self.videoInputDevice]) {
        [self.captureSession addInput:self.videoInputDevice];
    }
    if ([self.captureSession canAddInput:self.audioInputDevice]) {
        [self.captureSession addInput:self.audioInputDevice];
    }
    if([self.captureSession canAddOutput:self.videoDataOutput]){
        [self.captureSession addOutput:self.videoDataOutput];
        [self setVideoOutConfig];
    }
    if([self.captureSession canAddOutput:self.audioDataOutput]){
        [self.captureSession addOutput:self.audioDataOutput];
    }
    //设置分辨率
    if ([self.captureSession canSetSessionPreset:self.sessionPreset]) {
        self.captureSession.sessionPreset = self.sessionPreset;
    }
    
    [self.captureSession commitConfiguration];
}
#pragma mark - 设置输出配置
-(void)setVideoOutConfig
{
    for (AVCaptureConnection *conn in self.videoDataOutput.connections) {
        if (conn.isVideoStabilizationSupported) {
            [conn setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
        }
        if (conn.isVideoOrientationSupported) {
            [conn setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        if (conn.isVideoMirrored) {
            [conn setVideoMirrored:YES];
        }
    }
}
#pragma mark - 初始化预览图层
-(void) createPreviewLayer
{
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.previewLayer.frame = self.preview.bounds;
    [self.preview.layer addSublayer:self.previewLayer];
}
#pragma mark - 获取指定方向的摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (self.isCapturing) {
        if ([self.videoDataOutput isEqual:captureOutput]) {
            CVImageBufferRef pixelBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
            [self sendVideoBuffer:pixelBuffer];
        }else if([self.audioDataOutput isEqual:captureOutput]){
            [self sendAudioSample:sampleBuffer];
        }
    }
}
#pragma mark - 发送音视频桢数据
-(void)sendVideoBuffer:(CVImageBufferRef)videoBuffer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mhCaptureSendVideoBuffer:)]) {
        [self.delegate mhCaptureSendVideoBuffer:videoBuffer];
    }
}
#pragma mark -发送音频帧数据
-(void)sendAudioSample:(CMSampleBufferRef)sampleBuffer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mhCaptureSendAudioBuffer:)]) {
        [self.delegate mhCaptureSendAudioBuffer:sampleBuffer];
    }
}
#pragma mark - ------------------GPUImage采集----------------
#pragma mark - 初始化GPUImage
-(void)initGPUImageCamare
{
    self.videoCamera = [[MHGPUImageVideoCamera alloc] initWithSessionPreset:self.sessionPreset cameraPosition:AVCaptureDevicePositionFront];
    //声音 可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
    [_videoCamera addAudioInputsAndOutputs];
    //屏幕方向
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //镜像策略
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    //初始化相机预览图层
    self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.preview.bounds];
    self.gpuImageView.backgroundColor = [UIColor blackColor];
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.preview addSubview:self.gpuImageView];
    
    self.beautifyFilter = [[FSKGPUImageBeautyFilter alloc] init];
    [self.videoCamera addTarget:self.beautifyFilter];
    [self.beautifyFilter addTarget:self.gpuImageView];
    //imageSize需要根据分辨率计算
    self.dataHandler = [[MHGPUImageAVCaptureDataHandler alloc] initWithImageSize:CGSizeMake(640, 480) resultsInBGRAFormat:YES isCapture:self.isCapturing];
    self.dataHandler.mhGPUOutDelegate = self;
    [self.beautifyFilter addTarget:self.dataHandler];
}
#pragma mark - GPUImage数据代理
-(void)gpuImageSendAudioSample:(CMSampleBufferRef)sampleBuffer
{
    [self sendAudioSample:sampleBuffer];
}
-(void)gpuImageSendVideoBuffer:(CVImageBufferRef)videoBuffer
{
    [self sendVideoBuffer:videoBuffer];
}
#pragma mark - 开始采集
-(void)startCapture
{
    if (self.isCapturing) {
        NSLog(@"已经在采集视频了");
        return;
    }
    if (self.captureType == MHAVCaptureTypeSystem) {
        [self.captureSession startRunning];
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        [self.videoCamera startCameraCapture];
        self.dataHandler.isCapture = YES;
    }
}
#pragma mark - 停止采集
-(void)stopCapture
{
    if (!self.isCapturing) {
        NSLog(@"当前并未开始采集视频");
        return;
    }
    if (self.captureType == MHAVCaptureTypeSystem) {
        [self.captureSession stopRunning];
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        [self.videoCamera stopCameraCapture];
        self.dataHandler.isCapture = NO;
    }
}
#pragma mark - 设置帧率
-(void)changeFrameRate:(NSInteger)minFrameRate
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *vDevice in videoDevices) {
        float maxRate = [(AVFrameRateRange *)[vDevice.activeFormat.videoSupportedFrameRateRanges objectAtIndex:0] maxFrameRate];
        if (maxRate >= minFrameRate) {
            if ([vDevice lockForConfiguration:NULL]) {
                vDevice.activeVideoMinFrameDuration = CMTimeMake(10, (int)(minFrameRate * 10));
                vDevice.activeVideoMaxFrameDuration = vDevice.activeVideoMinFrameDuration;
                [vDevice unlockForConfiguration];
            }
        }
    }
    _minFrameRate = minFrameRate;
}
#pragma mark - 切换前后摄像头
-(void)switchCamera
{
    if (self.captureType == MHAVCaptureTypeSystem) {
        // 获取当前摄像头方向
        AVCaptureDevicePosition currentPosition = self.videoInputDevice.device.position;
        AVCaptureDevicePosition toPosition = AVCaptureDevicePositionUnspecified;
        if (currentPosition == AVCaptureDevicePositionBack || currentPosition == AVCaptureDevicePositionUnspecified) {
            toPosition = AVCaptureDevicePositionFront;
        } else {
            toPosition = AVCaptureDevicePositionBack;
        }
        AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:toPosition];
        if (!captureDevice) {
            NSLog(@"无法获取摄像头");
            return;
        }
        NSError *error = nil;
        AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        // 修改输入设备
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.videoInputDevice];
        if ([_captureSession canAddInput:newInput]) {
            [_captureSession addInput:newInput];
            self.videoInputDevice = newInput;
        }
        //更新连接方向
        [self setVideoOutConfig];
        [self.captureSession commitConfiguration];
        
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        [self.videoCamera rotateCamera];
    }
    
    //更新帧率
    [self changeFrameRate:self.minFrameRate];
}
#pragma mark - 采集过程中动态修改视频分辨率
- (void)changeSessionPreset:(AVCaptureSessionPreset)sessionPreset
{
    if (self.captureType == MHAVCaptureTypeSystem) {
        if ([self.captureSession canSetSessionPreset:sessionPreset]) {
            self.captureSession.sessionPreset = sessionPreset;
            _sessionPreset = sessionPreset;
        }
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        [self.videoCamera setCaptureSessionPreset:sessionPreset];
        _sessionPreset = sessionPreset;
    }
}
-(void)setPreViewRect:(CGRect)preViewRect
{
    _preViewRect = preViewRect;
    self.preview.frame = preViewRect;
    if (self.captureType == MHAVCaptureTypeSystem) {
        self.gpuImageView.frame = self.preview.bounds;
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        self.previewLayer.frame = self.preview.bounds;
    }
}
-(BOOL)isCapturing
{
    if (self.captureType == MHAVCaptureTypeSystem) {
        return self.captureSession.isRunning;
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        return self.videoCamera.isRunning;
    }
    return NO;
}
#pragma mark - 释放资源
-(void)dealloc
{
    if (self.captureType == MHAVCaptureTypeSystem) {
        if (self.captureSession) {
            [self.captureSession stopRunning];
        }
    }else if (self.captureType == MHAVCaptureTypeGPUImage) {
        [self.videoCamera stopCameraCapture];
        [self.videoCamera removeInputsAndOutputs];
        [self.videoCamera removeAllTargets];
        [self.beautifyFilter removeAllTargets];
        self.dataHandler = nil;
        self.beautifyFilter = nil;
        self.videoCamera = nil;
    }
    
}
@end




