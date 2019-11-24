//
//  MHHWH264Encoder.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/23.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHHWH264Encoder.h"
#import "MHBufferTools.h"

@implementation MHHWH264EncoderParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.encodeWidth = 480;
        self.encodeHeight = 640;
        self.bitRate = 1024 * 1024;
        self.frameRate = 30;
        self.maxKeyFrameInterval = 10;
    }
    return self;
}

@end

@interface MHHWH264Encoder ()

@property (assign, nonatomic) VTCompressionSessionRef compressionSessionRef;

@end

@implementation MHHWH264Encoder

-(instancetype)initWithParam:(MHHWH264EncoderParam *)param
{
    self = [super init];
    if (self) {
        if (!param) {
            param = [[MHHWH264EncoderParam alloc] init];
        }
        _param= param;
        [self buildEncoder];
    }
    return self;
}
#pragma mark - 结束/停止编码
- (BOOL)stopVideoEncode
{
    if (self.compressionSessionRef == NULL) {
        NSLog(@"编码器::调用顺序错误");
        return NO;
    }
    OSStatus status = VTCompressionSessionCompleteFrames(_compressionSessionRef, kCMTimeInvalid);
    if (noErr != status) {
        NSLog(@"结束编码失败 status:%d", (int)status);
        return NO;
    }
    return YES;
}
- (void)dealloc
{
    if (_compressionSessionRef == NULL) {
        return;
    }
    //停止编码
    VTCompressionSessionCompleteFrames(_compressionSessionRef, kCMTimeInvalid);
    //释放编码器
    VTCompressionSessionInvalidate(_compressionSessionRef);
    CFRelease(_compressionSessionRef);
    _compressionSessionRef = NULL;
}
#pragma mark - 创建编码器
-(void)buildEncoder
{
    // 创建硬编码器
    /*参数
     内存分配器，填NULL为默认分配器,
     视频帧像素的宽
     视频帧像素的高
     编码类型
     指定特定的编码器，填NULL的话由VideoToolBox自动选择
     源像素缓冲区的属性，如果这个参数有值的话，VideoToolBox会创建一个缓冲池，不需要缓冲池可以设置为NULL
     压缩后数据的内存分配器，填NULL使用默认分配器
     视频编码后输出数据回调函数
     回调函数中的自定义指针，通常传self，在回调函数中就可以拿到当前类的方法和属性了
     编码器句柄，传入编码器的指针
     */
    OSStatus status = VTCompressionSessionCreate(NULL,
                                                 (int)self.param.encodeWidth,
                                                 (int)self.param.encodeHeight,
                                                 kCMVideoCodecType_H264,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 encodeCallBack,
                                                 (__bridge void *)(self),
                                                 &_compressionSessionRef);
    if (status != noErr) {
        NSLog(@"编码器创建失败 status:%d", (int)status);
        return;
    }
    if (self.compressionSessionRef == NULL) {
        NSLog(@"编码器::调用顺序错误?????????");
        return;
    }
    // 设置码率 平均码率
    if (![self updateBitRate:self.param.bitRate]) {
        NSLog(@"设置码率失败");
    }
    //设置H264编码的画质
    /*
     实时直播：
     低清Baseline Level 1.3 kVTProfileLevel_H264_Baseline_3_1
     标清Baseline Level 3
     半高清Baseline Level 3.1
     全高清Baseline Level 4.1
     存储媒体：
     低清 Main Level 1.3
     标清 Main Level 3
     半高清 Main Level 3.1
     全高清 Main Level 4.1
     高清存储：
     半高清 High Level 3.1
     全高清 High Level 4.1
     */
    status = VTSessionSetProperty(_compressionSessionRef, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_4_1);
    if (status != noErr) {
        NSLog(@"设置编码画质失败 status:%d", (int)status);
    }
    //设置是否实时编码输出（避免延迟）
    status = VTSessionSetProperty(_compressionSessionRef, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    if (status != noErr) {
        NSLog(@"设置实时编码输出失败 status:%d", (int)status);
        return;
    }
    //配置是否产生B帧 false 默认不产生B帧
    status = VTSessionSetProperty(_compressionSessionRef, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
    if (status != noErr) {
        NSLog(@"配置是否产生B帧失败 status:%d", (int)status);
        return;
    }
    //配置I帧间隔
    status = VTSessionSetProperty(_compressionSessionRef,
                                  kVTCompressionPropertyKey_MaxKeyFrameInterval, (__bridge CFTypeRef)@(self.param.frameRate * self.param.maxKeyFrameInterval));
    if (status != noErr) {
        NSLog(@"配置I桢间隔失败 status:%d", (int)status);
        return;
    }
    status = VTSessionSetProperty(_compressionSessionRef,
                                  kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,
                                  (__bridge CFTypeRef)@(self.param.maxKeyFrameInterval));
    if (status != noErr) {
        NSLog(@"配置最大I桢间隔失败 status:%d", (int)status);
        return;
    }
    
    //编码器准备编码
    status = VTCompressionSessionPrepareToEncodeFrames(_compressionSessionRef);
    if (status != noErr) {
        NSLog(@"准备编码失败 status:%d", (int)status);
        return;
    }
}
#pragma mark - 设置码率
- (BOOL)updateBitRate:(NSInteger)bitRate
{
    if (bitRate <= 0) {
        NSLog(@"码率不能设置 <= 0");
        return NO;
    }
    OSStatus status = VTSessionSetProperty(_compressionSessionRef, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef)@(bitRate));
    if (status != noErr) {
        NSLog(@"设置码率失败 status:%d", (int)status);
        return NO;
    }
    
    // 参考webRTC 限制最大码率不超过平均码率的1.5倍
    int64_t dataLimitBytesPerSecondValue = bitRate * 1.5 / 8;
    CFNumberRef bytesPerSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &dataLimitBytesPerSecondValue);
    int64_t oneSecondValue = 1;
    CFNumberRef oneSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &oneSecondValue);
    const void* nums[2] = {bytesPerSecond, oneSecond};
    CFArrayRef dataRateLimits = CFArrayCreate(NULL, nums, 2, &kCFTypeArrayCallBacks);
    status = VTSessionSetProperty( _compressionSessionRef, kVTCompressionPropertyKey_DataRateLimits, dataRateLimits);
    if (status != noErr) {
        NSLog(@"限制最大码率失败 status:%d", (int)status);
        return NO;
    }
    return YES;
}
-(void)videoEncodeInputBuffer:(CVImageBufferRef)sampleBuffer
{
    if (self.compressionSessionRef == NULL || sampleBuffer == nil) {
        return;
    }
    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSessionRef,//创建编码器时的句柄
                                                      sampleBuffer,//Y_UV数据，
                                                      kCMTimeInvalid,//这一帧的时间戳，单位是毫秒
                                                      kCMTimeInvalid,//这一帧的持续时间，如果没有持续时间，填kCMTimeInvalid
                                                      NULL,//指定这一帧的属性，这里我们可以用来指定是否产生I帧
                                                      NULL,//自定义指针
                                                      NULL//用于接收编码操作的信息，不需要就置为NULL
                                                      );
    if (status != noErr) {
        NSLog(@"编码错误 status:%d", (int)status);
    }
}
#pragma mark - 编码器输出
void encodeCallBack(void * CM_NULLABLE outputCallbackRefCon,
                    void * CM_NULLABLE sourceFrameRefCon,
                    OSStatus status,
                    VTEncodeInfoFlags infoFlags,
                    CM_NULLABLE CMSampleBufferRef sampleBuffer)
{
    if (status != noErr || sampleBuffer == nil) {
        NSLog(@"编码错误 : %d!", (int)status);
        return;
    }
    if (outputCallbackRefCon == nil || !CMSampleBufferDataIsReady(sampleBuffer)) {
        return;
    }
    
    MHHWH264Encoder *encoder = (__bridge MHHWH264Encoder *)outputCallbackRefCon;
    // 开始码
    const char header[] = "\x00\x00\x00\x01";
    size_t headerLen = (sizeof header) - 1;
    NSData *headerData = [NSData dataWithBytes:header length:headerLen];
    
    //判断是否是关键帧
    BOOL isKeyFrame = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    if (isKeyFrame) {
        //NSLog(@"编码器::编码了一个关键帧");
        CMFormatDescriptionRef formatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        // 关键帧需要加上SPS、PPS信息
        size_t sParameterSetSize, sParameterSetCount;
        const uint8_t *sParameterSet;
        OSStatus spsStatus = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatDescriptionRef, 0, &sParameterSet, &sParameterSetSize, &sParameterSetCount, 0);
        
        size_t pParameterSetSize, pParameterSetCount;
        const uint8_t *pParameterSet;
        OSStatus ppsStatus = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatDescriptionRef, 1, &pParameterSet, &pParameterSetSize, &pParameterSetCount, 0);
        
        if (spsStatus == noErr && ppsStatus == noErr) {
            // sps数据加上开始码组成NALU
            NSData *sps = [NSData dataWithBytes:sParameterSet length:sParameterSetSize];
            NSData *pps = [NSData dataWithBytes:pParameterSet length:pParameterSetSize];
            NSMutableData *spsData = [NSMutableData data];
            [spsData appendData:headerData];
            [spsData appendData:sps];
            
            [encoder outPutEncodedData:spsData isKeyFrame:isKeyFrame];
            
            //pps数据加上开始码组成NALU
            NSMutableData *ppsData = [NSMutableData data];
            [ppsData appendData:headerData];
            [ppsData appendData:pps];
            
            [encoder outPutEncodedData:ppsData isKeyFrame:isKeyFrame];
        }
    }
    //获取帧数据
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    status = CMBlockBufferGetDataPointer(blockBuffer, 0, &length, &totalLength, &dataPointer);
    if (status != noErr) {
        NSLog(@"编码器获取帧数据失败 : %d!", (int)status);
        return;
    }
    
    size_t bufferOffset = 0;
    static const int avcHeaderLength = 4;
    while (bufferOffset < totalLength - avcHeaderLength) {
        // 读取 NAL 单元长度
        uint32_t nalUnitLength = 0;
        memcpy(&nalUnitLength, dataPointer + bufferOffset, avcHeaderLength);
        
        // 大端转小端
        nalUnitLength = CFSwapInt32BigToHost(nalUnitLength);
        
        NSData *frameData = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + avcHeaderLength) length:nalUnitLength];
        
        NSMutableData *outputFrameData = [NSMutableData data];
        [outputFrameData appendData:headerData];
        [outputFrameData appendData:frameData];
        
        bufferOffset += avcHeaderLength + nalUnitLength;
        
        [encoder outPutEncodedData:outputFrameData isKeyFrame:isKeyFrame];
    }
}
-(void)outPutEncodedData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame
{
    if ([self.delegate respondsToSelector:@selector(mhHWH264EncoderOutputData:isKeyFrame:)]) {
        [self.delegate mhHWH264EncoderOutputData:data isKeyFrame:isKeyFrame];
    }
}

@end
