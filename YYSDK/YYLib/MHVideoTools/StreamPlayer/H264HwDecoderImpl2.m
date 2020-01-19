//
//  H264HwDecoderImpl2.m
//  SecurityInPalm
//
//  Created by tl on 2018/6/20.
//  Copyright © 2018年 MEye_SecurityInPalm. All rights reserved.
//

#import "H264HwDecoderImpl2.h"
#import <UIKit/UIKit.h>

#define kH264outputWidth 352
#define kH264outputHeight 228

@interface H264HwDecoderImpl2() {
    size_t _vsize;
    
    uint8_t *_buf_out; // 原始接收的重组数据包
    
    uint8_t *_sps;
    size_t _spsSize;
    uint8_t *_pps;
    size_t _ppsSize;
    uint8_t *_vps;
    size_t _vpsSize;
    
    VTDecompressionSessionRef _deocderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
    
    CGFloat _out_width;
    CGFloat _out_height;
    
    NSString *_imagePath;
    BOOL _isSaveImage;
    NSMutableData *_mData;
    
    VideoSteamType _videoType;
    
    BOOL hasSwitchedDecoderSteamType;
}

@property (nonatomic, copy) void (^snapshotHandler)(UIImage *);

@end

@implementation H264HwDecoderImpl2

static const uint8_t *avc_find_startcode_internal(const uint8_t *p, const uint8_t *end) {
    const uint8_t *a = p + 4 - ((intptr_t)p & 3);
    
    for (end -= 3; p < a && p < end; p++) {
        if (p[0] == 0 && p[1] == 0 && p[2] == 1)
            return p;
    }
    
    for (end -= 3; p < end; p += 4) {
        uint32_t x = *(const uint32_t*)p;
        //      if ((x - 0x01000100) & (~x) & 0x80008000) // little endian
        //      if ((x - 0x00010001) & (~x) & 0x00800080) // big endian
        if ((x - 0x01010101) & (~x) & 0x80808080) { // generic
            if (p[1] == 0) {
                if (p[0] == 0 && p[2] == 1)
                    return p;
                if (p[2] == 0 && p[3] == 1)
                    return p+1;
            }
            if (p[3] == 0) {
                if (p[2] == 0 && p[4] == 1)
                    return p+2;
                if (p[4] == 0 && p[5] == 1)
                    return p+3;
            }
        }
    }
    
    for (end += 3; p < end; p++) {
        if (p[0] == 0 && p[1] == 0 && p[2] == 1)
            return p;
    }
    
    return end + 3;
}

const uint8_t *avc_find_startcode(const uint8_t *p, const uint8_t *end) {
    const uint8_t *out= avc_find_startcode_internal(p, end);
    if(p<out && out<end && !out[-1]) out--;
    
    return out;
}

//解码回调函数
static void didDecompress(void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef imageBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ) {
    if (status != noErr || imageBuffer == nil) {
        return;
    }
    if (kVTDecodeInfo_FrameDropped & infoFlags) {
        return;
    }
    __weak H264HwDecoderImpl2 *decoder = (__bridge H264HwDecoderImpl2 *)decompressionOutputRefCon;
    
    [decoder imageFromSampleBuffer:imageBuffer];
}

- (void)saveImageToPath:(NSString *)aPath {
    _imagePath = aPath;
    _isSaveImage = YES;
}

- (void)getSnapshot:(void (^)(UIImage *))handler {
    _isSaveImage = YES;
    _snapshotHandler = handler;
}

- (void)imageFromSampleBuffer:(CVImageBufferRef)pixelBufffer {
    if (!_isSaveImage) {
        return;
    }
    _isSaveImage = NO;
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBufffer),
                                                 CVPixelBufferGetHeight(pixelBufffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
    CGImageRelease(videoImage);
    if (_snapshotHandler) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.snapshotHandler(image);
//            self.snapshotHandler = nil;
//        });
        _snapshotHandler(image);
        _snapshotHandler = nil;
    }
    
    if (_imagePath) {
        [UIImagePNGRepresentation(image) writeToFile:_imagePath atomically:YES];
        _imagePath = nil;
    }
    NSLog(@"成功 currentThread = %@",[NSThread currentThread]);
}

- (instancetype)initWithType:(VideoSteamType)type {
    return [self initWithType:type size:CGSizeMake(kH264outputWidth, kH264outputHeight)];
}

- (instancetype)initWithType:(VideoSteamType)type size:(CGSize)size {
    if (self = [super init]) {
        _videoType = type;
        _out_width = size.width;
        _out_height = size.height;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    if (_out_width <= 0) { _out_width = kH264outputWidth; }
    if (_out_height <= 0) { _out_width = kH264outputHeight; }
    _vsize = _out_width * _out_height * 3;
    _mData = [NSMutableData data];
    _buf_out = (uint8_t*)malloc(_out_width * _out_height * sizeof(uint8_t));
}

- (void)closed {
    if(_deocderSession) {
        VTDecompressionSessionInvalidate(_deocderSession);
        CFRelease(_deocderSession);
        _deocderSession = NULL;
    }
    
    if(_decoderFormatDescription) {
        CFRelease(_decoderFormatDescription);
        _decoderFormatDescription = NULL;
    }
    
    free(_sps);
    free(_pps);
    free(_vps);
    free(_buf_out);
}

- (BOOL)initH264Decoder {
    if (_deocderSession) {
        return YES;
    }
    
    if (_videoType == VideoSteamType_H264) {
        if (!_sps || !_pps || _spsSize == 0 || _ppsSize == 0) {
            return NO;
        }
        
        const uint8_t* const parameterSetPointers[2] = { _sps, _pps };
        const size_t parameterSetSizes[2] = { _spsSize, _ppsSize };
        OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                              2, //param count
                                                                              parameterSetPointers,
                                                                              parameterSetSizes,
                                                                              4, //nal start code size
                                                                              &_decoderFormatDescription);
        
        if (status == noErr) {
            NSDictionary* destinationPixelBufferAttributes = @{
                (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
                //硬解必须是 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange 或者是kCVPixelFormatType_420YpCbCr8Planar
                //因为iOS是nv12  其他是nv21
                , (id)kCVPixelBufferWidthKey  : [NSNumber numberWithInt:_out_width]
                , (id)kCVPixelBufferHeightKey : [NSNumber numberWithInt:_out_height]
                , (id)kCVPixelBufferOpenGLCompatibilityKey : [NSNumber numberWithBool:NO]
                , (id)kCVPixelBufferOpenGLESCompatibilityKey : [NSNumber numberWithBool:YES]
            };
            
            VTDecompressionOutputCallbackRecord callBackRecord;
            callBackRecord.decompressionOutputCallback = didDecompress;
            callBackRecord.decompressionOutputRefCon = (__bridge void *)self;
            
            status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                                  _decoderFormatDescription,
                                                  NULL,
                                                  (__bridge CFDictionaryRef)destinationPixelBufferAttributes,
                                                  &callBackRecord,
                                                  &_deocderSession);
            VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)[NSNumber numberWithInt:1]);
            VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);
        } else {
            NSLog(@"reset decoder session failed status=%d", (int)status);
            return NO;
        }
    }else {
        if (!_sps || !_pps || !_vps || _spsSize == 0 || _ppsSize == 0 || _vpsSize == 0) {
            return NO;
        }
        
        const uint8_t* const parameterSetPointers[3] = { _vps,_sps, _pps };
        const size_t parameterSetSizes[3] = { _vpsSize,_spsSize, _ppsSize };
        if (@available(iOS 11.0, *)) {
            OSStatus status = CMVideoFormatDescriptionCreateFromHEVCParameterSets(kCFAllocatorDefault, 3, parameterSetPointers, parameterSetSizes, 4, NULL, &_decoderFormatDescription);
            
            
            if (status == noErr) {
                NSDictionary* destinationPixelBufferAttributes = @{
                    (id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
                    , (id)kCVPixelBufferWidthKey  : [NSNumber numberWithInt:_out_width]
                    , (id)kCVPixelBufferHeightKey : [NSNumber numberWithInt:_out_height]
                    , (id)kCVPixelBufferOpenGLCompatibilityKey : [NSNumber numberWithBool:NO]
                    , (id)kCVPixelBufferOpenGLESCompatibilityKey : [NSNumber numberWithBool:YES]
                };
                
                VTDecompressionOutputCallbackRecord callBackRecord;
                callBackRecord.decompressionOutputCallback = didDecompress;
                callBackRecord.decompressionOutputRefCon = (__bridge void *)self;
                
                status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                                      _decoderFormatDescription,
                                                      NULL,
                                                      (__bridge CFDictionaryRef)destinationPixelBufferAttributes,
                                                      &callBackRecord,
                                                      &_deocderSession);
                VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)[NSNumber numberWithInt:1]);
                VTSessionSetProperty(_deocderSession, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);
            } else {
                NSLog(@"reset decoder session failed status=%d", (int)status);
                return NO;
            }
        } else {
            NSLog(@"CMVideoFormatDescriptionCreateFromHEVCParameterSets not support");
        }
    }
    
    
    
    return YES;
}

- (BOOL)resetH264Decoder {
    if(_deocderSession) {
        VTDecompressionSessionWaitForAsynchronousFrames(_deocderSession);
        VTDecompressionSessionInvalidate(_deocderSession);
        CFRelease(_deocderSession);
        _deocderSession = NULL;
    }
    return [self initH264Decoder];
}

- (CMSampleBufferRef)decode:(uint8_t *)frame withSize:(uint32_t)frameSize {
    if (frame == NULL || _deocderSession == nil)
        return NULL;
    //    NSLog(@"frameSize = %u",frameSize);
    CMSampleBufferRef sampleBuffer = NULL;
    CVPixelBufferRef outputPixelBuffer = NULL;
    CMBlockBufferRef blockBuffer = NULL;
    
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(NULL,
                                                          (void *)frame,
                                                          frameSize,
                                                          kCFAllocatorNull,
                                                          NULL,
                                                          0,
                                                          frameSize,
                                                          FALSE,
                                                          &blockBuffer);
    
    if(status == kCMBlockBufferNoErr) {
        status = CMSampleBufferCreate(NULL, blockBuffer, TRUE, 0, 0, _decoderFormatDescription, 1, 0, NULL, 0, NULL, &sampleBuffer);
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            status = VTDecompressionSessionDecodeFrame(_deocderSession,
                                                       sampleBuffer,
                                                       flags,
                                                       &outputPixelBuffer,
                                                       &flagOut);
            
            if (status == kVTInvalidSessionErr) {
                NSLog(@"Invalid session, reset decoder session");
                [self resetH264Decoder];
            } else if(status == kVTVideoDecoderBadDataErr) {
                NSLog(@"decode failed status=%d(Bad data)", (int)status);
            } else if(status != noErr) {
                NSLog(@"decode failed status=%d", (int)status);
            }
        }
        
    }
    if (outputPixelBuffer != NULL)
        CVPixelBufferRelease(outputPixelBuffer);
    if (blockBuffer != NULL)
        CFRelease(blockBuffer);
    
    return sampleBuffer;
}

- (void)decodeNalu:(uint8_t *)frame withSize:(uint32_t)frameSize {
    if (frame == NULL || frameSize == 0) {
        return;
    }
    
    int size = frameSize;
    const uint8_t *p = frame;
    const uint8_t *end = p + size;
    const uint8_t *nal_start, *nal_end;
    int nal_len, nalu_type;
    
    size = 0;
    nal_start = avc_find_startcode(p, end);
    while (![[NSThread currentThread] isCancelled]) {
        while (![[NSThread currentThread] isCancelled] && nal_start < end && !*(nal_start++));
        if (nal_start == end)
            break;
        
        nal_end = avc_find_startcode(nal_start, end);
        nal_len = (int)(nal_end - nal_start);
        if (_videoType == VideoSteamType_H264) {
            
            nalu_type = nal_start[0] & 0x1f;
            if (nalu_type == 0x07) {
                if (_sps == NULL) {
                    _spsSize = nal_len;
                    _sps = (uint8_t*)malloc(_spsSize);
                    memcpy(_sps, nal_start, _spsSize);
                }
            }
            else if (nalu_type == 0x08) {
                if (_pps == NULL) {
                    _ppsSize = nal_len;
                    _pps = (uint8_t*)malloc(_ppsSize);
                    memcpy(_pps, nal_start, _ppsSize);
                }
            }
            else {
                _buf_out[size + 0] = (uint8_t)(nal_len >> 24);
                _buf_out[size + 1] = (uint8_t)(nal_len >> 16);
                _buf_out[size + 2] = (uint8_t)(nal_len >> 8 );
                _buf_out[size + 3] = (uint8_t)(nal_len);
                
                memcpy(_buf_out + 4 + size, nal_start, nal_len);
                size += 4 + nal_len;
            }
            
            
        }else {
            nalu_type = nal_start[0]>>1;
            
            if (nalu_type == 32) {
                if (_vps == NULL) {
                    _vpsSize = nal_len;
                    _vps = (uint8_t*)malloc(_vpsSize);
                    memcpy(_vps, nal_start, _vpsSize);
                }
            }
            
            else if (nalu_type == 33) {
                if (_sps == NULL) {
                    _spsSize = nal_len;
                    _sps = (uint8_t*)malloc(_spsSize);
                    memcpy(_sps, nal_start, _spsSize);
                }
            }
            else if (nalu_type == 34) {
                if (_pps == NULL) {
                    _ppsSize = nal_len;
                    _pps = (uint8_t*)malloc(_ppsSize);
                    memcpy(_pps, nal_start, _ppsSize);
                }
            }
            else {
                _buf_out[size + 0] = (uint8_t)(nal_len >> 24);
                _buf_out[size + 1] = (uint8_t)(nal_len >> 16);
                _buf_out[size + 2] = (uint8_t)(nal_len >> 8 );
                _buf_out[size + 3] = (uint8_t)(nal_len);
                
                memcpy(_buf_out + 4 + size, nal_start, nal_len);
                size += 4 + nal_len;
            }
            
        }
        nal_start = nal_end;
    }
    
    if ([self initH264Decoder]) {
        CMSampleBufferRef pixelBuffer = NULL;
        pixelBuffer = [self decode:_buf_out withSize:size];
        if (pixelBuffer) {
            CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(pixelBuffer, YES);
            CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
            CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
            [self.delegate displayDecodedFrame:pixelBuffer];
        }
    }
}


@end
