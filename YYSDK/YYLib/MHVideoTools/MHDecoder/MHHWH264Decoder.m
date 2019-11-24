//
//  MHH264Decoder.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/23.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHHWH264Decoder.h"
#import "MHBufferTools.h"

#ifndef FreeCharP
#define FreeCharP(p) if (p) {free(p); p = NULL;}
#endif

typedef enum : NSUInteger {
    MHVideoFrameType_UNKNOWN = 0,
    MHVideoFrameType_I,
    MHVideoFrameType_P,
    MHVideoFrameType_B,
    MHVideoFrameType_SPS,
    MHVideoFrameType_PPS,
    MHVideoFrameType_SEI,
} MHVideoFrameType;


static void didDecompress(void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration )
{
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

@interface MHHWH264Decoder ()
{
    VTDecompressionSessionRef mDeocderSession;
    CMVideoFormatDescriptionRef mDecoderFormatDescription;
    
    uint8_t *pSPS;
    uint8_t *pPPS;
    uint8_t *pSEI;
    NSInteger mSpsSize;
    NSInteger mPpsSize;
    NSInteger mSeiSize;
    
    NSInteger mINalCount;        //I帧起始码个数
    NSInteger mPBNalCount;       //P、B帧起始码个数
    NSInteger mINalIndex;       //I帧起始码开始位
    
    BOOL mIsNeedReinit;         //需要重置解码器
}

@end

@implementation MHHWH264Decoder

- (id)init
{
    if (self = [super init]) {
        pSPS = pPPS = pSEI = NULL;
        mSpsSize = mPpsSize = mSeiSize = 0;
        mINalCount = mPBNalCount = mINalIndex = 0;
        mIsNeedReinit = NO;
        
        _outPutType = MHHWH264DecoderOutPutType_y_uv;
    }
    return self;
}
#pragma mark - 创建解码器
- (BOOL)initH264MHDecoder
{
    if (mDeocderSession) {
        return YES;
    }
    
    const uint8_t *const parameterSetPointers[2] = {pSPS,pPPS};
    const size_t parameterSetSizes[2] = {mSpsSize, mPpsSize};
    
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault, 2, parameterSetPointers, parameterSetSizes, 4, &mDecoderFormatDescription);
    if (status != noErr) {
        NSLog(@"Init H264 hardware decoder fail: %d", (int)status);
        return NO;
    }
    // 从sps pps中获取解码视频的宽高信息
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(mDecoderFormatDescription);
    /*
     Planar: 平面；BiPlanar：双平面 平面／双平面主要应用在yuv上。uv分开存储的为Planar(y_u_v)，反之是BiPlanar(y_uv)
     kCVPixelFormatType_420YpCbCr8PlanarFullRange是420p， 播放时需要使用Y_U_V模式播放YUVdata
     kCVPixelFormatType_420YpCbCr8BiPlanarFullRange是nv12. 播放时使用Y_UV模式CVPixelBufferRef
     
     VideoRange和FullRange的区别在于数值的范围，FullRange比VideoRange大一些，颜色也更丰富一些。
     如果没有指定颜色范围，默认都是FullRange
     */
    uint32_t pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;//NV12 y_uv 420f
    if (self.outPutType == MHHWH264DecoderOutPutType_y_u_v) {
        pixelFormatType = kCVPixelFormatType_420YpCbCr8PlanarFullRange;//420p y_u_v f420
    }
    
    // kCVPixelBufferWidthKey、kCVPixelBufferHeightKey 解码图像的宽高
    // kCVPixelBufferOpenGLCompatibilityKey指定支持OpenGL渲染
    NSDictionary* destinationPixelBufferAttributes = @{
        (id)kCVPixelBufferPixelFormatTypeKey : @(pixelFormatType),
        (id)kCVPixelBufferWidthKey : @(dimensions.width),
        (id)kCVPixelBufferHeightKey : @(dimensions.height),
        (id)kCVPixelBufferOpenGLCompatibilityKey : @(YES)
    };
    
    VTDecompressionOutputCallbackRecord callBackRecord;
    callBackRecord.decompressionOutputCallback = didDecompress;
    callBackRecord.decompressionOutputRefCon = NULL;
    
    status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                          mDecoderFormatDescription,
                                          NULL,
                                          (__bridge CFDictionaryRef)destinationPixelBufferAttributes,
                                          &callBackRecord,
                                          &mDeocderSession);
    //CFRelease(attrs);
    if (status != kCMBlockBufferNoErr) {
        NSLog(@"Init H264 hardware decoder failed = %d",(int)status);
        return NO;
    }
    NSLog(@"Init H264 hardware decoder success");
    return YES;
}
//将视频数据封装成CMSampleBufferRef进行解码
- (CVPixelBufferRef)decode:(uint8_t *)videoBuffer videoSize:(NSInteger)videoBufferSize
{
    CVPixelBufferRef outputPixelBuffer = NULL;
    
    // 创建 CMBlockBufferRef
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault, (void *)videoBuffer, videoBufferSize, kCFAllocatorNull, NULL, 0, videoBufferSize, 0, &blockBuffer);
    if (status != kCMBlockBufferNoErr) {
        NSLog(@"CMBlockBufferCreateWithMemoryBlock 创建 CMBlockBufferRef failed = %d",(int)status);
        return outputPixelBuffer;
    }
    
    // 创建 CMSampleBufferRef
    CMSampleBufferRef sampleBuffer = NULL;
    const size_t sampleSizeArray[] = { videoBufferSize };
    status = CMSampleBufferCreateReady(kCFAllocatorDefault, blockBuffer, mDecoderFormatDescription , 1, 0, NULL, 1, sampleSizeArray, &sampleBuffer);
    if (status != kCMBlockBufferNoErr || sampleBuffer == NULL) {
        NSLog(@"CMSampleBufferCreateReady 创建 CMSampleBufferRef failed = %d",(int)status);
        return outputPixelBuffer;
    }
    
    VTDecodeFrameFlags flags = 0;
    VTDecodeInfoFlags flagOut = 0;
    OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(mDeocderSession, sampleBuffer, flags, &outputPixelBuffer, &flagOut);
    
    if (decodeStatus == kVTVideoDecoderMalfunctionErr) {
        NSLog(@"Decode failed status: kVTVideoDecoderMalfunctionErr");
        CVPixelBufferRelease(outputPixelBuffer);
        outputPixelBuffer = NULL;
    } else if(decodeStatus == kVTInvalidSessionErr) {
        NSLog(@"Invalid session, reset decoder session");
        [self removeH264MHDecoder];
    } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
        NSLog(@"Decode failed status=%d(Bad data)", (int)decodeStatus);
    } else if(decodeStatus != noErr) {
        NSLog(@"Decode failed status=%d", (int)decodeStatus);
    }
    
    CFRelease(sampleBuffer);
    CFRelease(blockBuffer);
    
    return outputPixelBuffer;
}
#pragma mark - 输入视频帧数据，开始解码

-(void)decodeH264VideoData:(NSData *)videoData {
    uint8_t *frame = (uint8_t *)videoData.bytes;
    uint32_t videoSize = (uint32_t)videoData.length;
    [self decodeH264VideoData:frame videoSize:videoSize];
}

- (void)decodeH264VideoData:(uint8_t *)frame videoSize:(uint32_t)videoSize {
    if (!frame || videoSize <= 0) {
        return;
    }
    
    MHVideoFrameType frameFlag = [self analyticalData:frame size:videoSize];
    if (mIsNeedReinit) {
        mIsNeedReinit = NO;
        [self removeH264MHDecoder];
    }
    
    if (pSPS && pPPS && (frameFlag == MHVideoFrameType_I || frameFlag == MHVideoFrameType_P || frameFlag == MHVideoFrameType_B)) {
        uint8_t *buffer = NULL;
        if (frameFlag == MHVideoFrameType_I) {
            int nalExtra = (mINalCount==3?1:0);      //如果是3位的起始码，转为大端时需要增加1位
            videoSize -= mINalIndex;
            buffer = (uint8_t *)malloc(videoSize + nalExtra);
            memcpy(buffer + nalExtra, frame + mINalIndex, videoSize);
            videoSize += nalExtra;
        } else {
            int nalExtra = (mPBNalCount==3?1:0);
            buffer = (uint8_t *)malloc(videoSize + nalExtra);
            memcpy(buffer + nalExtra, frame, videoSize);
            videoSize += nalExtra;
        }
        
        uint32_t nalSize = (uint32_t)(videoSize - 4);
        uint32_t *pNalSize = (uint32_t *)buffer;
        *pNalSize = CFSwapInt32HostToBig(nalSize);
        
        CVPixelBufferRef pixelBuffer = NULL;
        
        if (![self initH264MHDecoder]) {
            FreeCharP(buffer);
            return;
        }
        
        pixelBuffer = [self decode:buffer videoSize:videoSize];
        
        if (!pixelBuffer || pixelBuffer == NULL) {
            FreeCharP(buffer);
            return;
        }
        //若B帧未进行乱序解码，顺序播放，则在此需要去除，否则解码图形则是灰色.
        if (frameFlag == MHVideoFrameType_B) {
            size_t planeCount = CVPixelBufferGetPlaneCount(pixelBuffer);
            if (planeCount >= 2 && planeCount <= 3) {
                CVPixelBufferLockBaseAddress(pixelBuffer, 0);
                u_char *yDestPlane = (u_char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
                if (planeCount == 2) {
                    u_char *uvDestPlane = (u_char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
                    if (yDestPlane[0] == 0x80 && uvDestPlane[0] == 0x80 && uvDestPlane[1] == 0x80) {
                        frameFlag = MHVideoFrameType_UNKNOWN;
                        NSLog(@"Video YUV data parse error: Y=%02x U=%02x V=%02x", yDestPlane[0], uvDestPlane[0], uvDestPlane[1]);
                    }
                } else if (planeCount == 3) {
                    u_char *uDestPlane = (u_char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
                    u_char *vDestPlane = (u_char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 2);
                    if (yDestPlane[0] == 0x80 && uDestPlane[0] == 0x80 && vDestPlane[0] == 0x80) {
                        frameFlag = MHVideoFrameType_UNKNOWN;
                        NSLog(@"Video YUV data parse error: Y=%02x U=%02x V=%02x", yDestPlane[0], uDestPlane[0], vDestPlane[0]);
                    }
                }
                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            }
        }
        if (frameFlag == MHVideoFrameType_UNKNOWN) {
            CVPixelBufferRelease(pixelBuffer);
            FreeCharP(buffer);
            return;
        }
        if (self.outPutType == MHHWH264DecoderOutPutType_y_uv) {
            CVPixelBufferRetain(pixelBuffer);
            //输出pixelBuffer
            if (self.delegate && [self.delegate respondsToSelector:@selector(mhHWH264DecoderOuPutY_uvPixel:)]) {
                [self.delegate mhHWH264DecoderOuPutY_uvPixel:pixelBuffer];
            }
            
        }else if (self.outPutType == MHHWH264DecoderOutPutType_y_u_v) {
            //输出yuvData
            if (self.delegate && [self.delegate respondsToSelector:@selector(mhHWH264DecoderOuPutY_U_VData:frameWidth:height:)]) {
                MHVideoData videoData = [MHBufferTools convertVideoBufferToY_U_VData:pixelBuffer];
                [self.delegate mhHWH264DecoderOuPutY_U_VData:videoData.videoData frameWidth:videoData.width height:videoData.height];
            }
            
        }else if (self.outPutType == MHHWH264DecoderOutPutType_imageref) {
            //这里很耗性能!!!!!
            CGImageRef imgRef = [MHBufferTools imageRefFromimageBuffer:pixelBuffer];
            //输出CGImageRef
            if (self.delegate && [self.delegate respondsToSelector:@selector(mhHWH264DecoderOutPutImageref:)]) {
                [self.delegate mhHWH264DecoderOutPutImageref:imgRef];
            }
        }
        CVPixelBufferRelease(pixelBuffer);
        FreeCharP(buffer);
    }
}

//从起始位开始查询SPS、PPS、SEI、I、B、P帧起始码，遇到I、P、B帧则退出
//存在多种情况：
//1、起始码是0x0 0x0 0x0 0x01 或 0x0 0x0 0x1
//2、每个SPS、PPS、SEI、I、B、P帧为单独的Slice
//3、I帧中包含SPS、PPS、I数据Slice
//4、I帧中包含第3点的数据之外还包含SEI，顺序：SPS、PPS、SEI、I
//5、起始位是AVCC协议格式的大端数据(不支持多Slice的视频帧)
- (MHVideoFrameType)analyticalData:(const uint8_t *)buffer size:(NSInteger)size
{
    NSInteger preIndex = 0;
    MHVideoFrameType preFrameType = MHVideoFrameType_UNKNOWN;
    MHVideoFrameType curFrameType = MHVideoFrameType_UNKNOWN;
    for (int i=0; i<size && i<300; i++) {       //一般第四种情况下的帧起始信息不会超过(32+256+12)位，可适当增大，为了不循环整个帧片数据
        int nalSize = [self getNALHeaderLen:(buffer + i) size:size-i];
        if (nalSize == 0 && i == 0) {   //当每个Slice起始位开始若使用AVCC协议则判断帧大小是否一致
            uint32_t *pNalSize = (uint32_t *)(buffer);
            uint32_t videoSize = CFSwapInt32BigToHost(*pNalSize);    //大端模式转为系统端模式
            if (videoSize == size - 4) {     //是大端模式(AVCC)
                nalSize = 4;
            }
        }
        
        if (nalSize && i + nalSize + 1 < size) {
            int sliceType = buffer[i + nalSize] & 0x1F;
            
            if (sliceType == 0x1) {
                mPBNalCount = nalSize;
                if (buffer[i + nalSize] == 0x1) {   //B帧
                    curFrameType = MHVideoFrameType_B;
                } else {    //P帧
                    curFrameType = MHVideoFrameType_P;
                }
                break;
            } else if (sliceType == 0x5) {     //IDR(I帧)
                if (preFrameType == MHVideoFrameType_PPS) {
                    mIsNeedReinit = [self getSliceInfo:buffer slice:&pPPS size:&mPpsSize start:preIndex end:i];
                } else if (preFrameType == MHVideoFrameType_SEI)  {
                    [self getSliceInfo:buffer slice:&pSEI size:&mSeiSize start:preIndex end:i];
                }
                
                mINalCount = nalSize;
                mINalIndex = i;
                curFrameType = MHVideoFrameType_I;
                goto Goto_Exit;
            } else if (sliceType == 0x7) {      //SPS
                preFrameType = MHVideoFrameType_SPS;
                preIndex = i + nalSize;
                i += nalSize;
            } else if (sliceType == 0x8) {      //PPS
                if (preFrameType == MHVideoFrameType_SPS) {
                    mIsNeedReinit = [self getSliceInfo:buffer slice:&pSPS size:&mSpsSize start:preIndex end:i];
                }
                
                preFrameType = MHVideoFrameType_PPS;
                preIndex = i + nalSize;
                i += nalSize;
            } else if (sliceType == 0x6) {      //SEI
                if (preFrameType == MHVideoFrameType_PPS) {
                    mIsNeedReinit = [self getSliceInfo:buffer slice:&pPPS size:&mPpsSize start:preIndex end:i];
                }
                
                preFrameType = MHVideoFrameType_SEI;
                preIndex = i + nalSize;
                i += nalSize;
            }
        }
    }
    
    //SPS、PPS、SEI为单独的Slice帧片
    if (curFrameType == MHVideoFrameType_UNKNOWN && preIndex != 0) {
        if (preFrameType == MHVideoFrameType_SPS) {
            mIsNeedReinit = [self getSliceInfo:buffer slice:&pSPS size:&mSpsSize start:preIndex end:size];
            curFrameType = MHVideoFrameType_SPS;
        } else if (preFrameType == MHVideoFrameType_PPS) {
            mIsNeedReinit = [self getSliceInfo:buffer slice:&pPPS size:&mPpsSize start:preIndex end:size];
            curFrameType = MHVideoFrameType_PPS;
        } else if (preFrameType == MHVideoFrameType_SEI)  {
            [self getSliceInfo:buffer slice:&pSEI size:&mSeiSize start:preIndex end:size];
            curFrameType = MHVideoFrameType_SEI;
        }
    }
    
Goto_Exit:
    return curFrameType;
}

//获取NAL的起始码长度是3还4
- (int)getNALHeaderLen:(const uint8_t *)buffer size:(NSInteger)size
{
    if (size >= 4 && buffer[0] == 0x0 && buffer[1] == 0x0 && buffer[2] == 0x0 && buffer[3] == 0x1) {
        return 4;
    } else if (size >= 3 && buffer[0] == 0x0 && buffer[1] == 0x0 && buffer[2] == 0x1) {
        return 3;
    }
    
    return 0;
}

//给SPS、PPS、SEI的Buf赋值，返回YES表示不同于之前的值
- (BOOL)getSliceInfo:(const uint8_t *)videoBuf slice:(uint8_t **)sliceBuf size:(NSInteger *)size start:(NSInteger)start end:(NSInteger)end
{
    BOOL isDif = NO;
    NSInteger len = end - start;
    uint8_t *tempBuf = (uint8_t *)(*sliceBuf);
    if (tempBuf) {
        if (len != *size || memcmp(tempBuf, videoBuf + start, len) != 0) {
            free(tempBuf);
            tempBuf = (uint8_t *)malloc(len);
            memcpy(tempBuf, videoBuf + start, len);
            *sliceBuf = tempBuf;
            *size = len;
            isDif = YES;
        }
    } else {
        tempBuf = (uint8_t *)malloc(len);
        memcpy(tempBuf, videoBuf + start, len);
        *sliceBuf = tempBuf;
        *size = len;
    }
    return isDif;
}
#pragma mark - 释放解码器
- (void)releaseH264Decoder
{
    [self removeH264MHDecoder];
    [self releaseSliceInfo];
}
- (void)removeH264MHDecoder
{
    if(mDeocderSession) {
        VTDecompressionSessionInvalidate(mDeocderSession);
        CFRelease(mDeocderSession);
        mDeocderSession = NULL;
    }
    
    if(mDecoderFormatDescription) {
        CFRelease(mDecoderFormatDescription);
        mDecoderFormatDescription = NULL;
    }
}
- (void)releaseSliceInfo
{
    FreeCharP(pSPS);
    FreeCharP(pPPS);
    FreeCharP(pSEI);
    
    mSpsSize = mPpsSize = mSeiSize = 0;
    mINalCount = mPBNalCount = mINalIndex = 0;
    mIsNeedReinit = NO;
}
- (void)dealloc
{
    [self releaseH264Decoder];
}
@end
