//
//  MHHWAACDecoder.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/28.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHHWAACDecoder.h"

@interface MHHWAACDecoder ()

@property (nonatomic,assign) AudioConverterRef aConverter;

@end

@implementation MHHWAACDecoder

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAudioConverter];
    }
    return self;
}
// 初始化AAC解码器
- (void)setupAudioConverter
{
    //输入流参数
    AudioStreamBasicDescription inFormat;
    memset(&inFormat, 0, sizeof(inFormat));
    inFormat.mSampleRate = 44100;
    inFormat.mFormatID = kAudioFormatMPEG4AAC;
    inFormat.mFormatFlags = kMPEG4Object_AAC_LC;
    inFormat.mBytesPerPacket = 0;
    inFormat.mFramesPerPacket = 1024;
    inFormat.mBytesPerFrame = 0;
    inFormat.mChannelsPerFrame = 1;
    inFormat.mBitsPerChannel = 0;
    inFormat.mReserved = 0;
    //输出流参数
    AudioStreamBasicDescription outFormat;
    memset(&outFormat, 0, sizeof(outFormat));
    outFormat.mSampleRate = 44100;
    outFormat.mFormatID = kAudioFormatLinearPCM;
    outFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
    outFormat.mFramesPerPacket = 1;
    outFormat.mBitsPerChannel = 16;
    outFormat.mChannelsPerFrame = 1;
    outFormat.mBytesPerFrame = outFormat.mBitsPerChannel / 8 * outFormat.mChannelsPerFrame;
    outFormat.mBytesPerPacket = outFormat.mBytesPerFrame * outFormat.mFramesPerPacket;
    outFormat.mReserved = 0;
    
    //3.编码器参数
    AudioClassDescription requestedCodecs[2] = {
        {kAudioDecoderComponentType, kAudioFormatLinearPCM, kAppleSoftwareAudioCodecManufacturer},
        {kAudioDecoderComponentType, kAudioFormatLinearPCM, kAppleHardwareAudioCodecManufacturer}
    };
    //4.编码器
    OSStatus status = AudioConverterNewSpecific(&inFormat, &outFormat, 2, requestedCodecs, &_aConverter);
    if (status != noErr) {
        NSLog(@"初始化aac解码器失败");
    }
}
// AudioCallBack
OSStatus outputDataProc(AudioConverterRef inConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData,AudioStreamPacketDescription **outDataPacketDescription, void *inUserData) {
    
    AudioBufferList bufferList = *(AudioBufferList*)inUserData;
    ioData->mBuffers[0].mData = bufferList.mBuffers[0].mData;
    ioData->mBuffers[0].mDataByteSize = bufferList.mBuffers[0].mDataByteSize;
    
    return noErr;
}
// 输入解码数据开始解码
-(void)audioDecodeAACData:(NSData *)aacData
{
    if(!_aConverter){
        [self setupAudioConverter];
    }
    
    AudioBufferList inAudioBufferList;
    inAudioBufferList.mBuffers[0].mNumberChannels = 1;
    inAudioBufferList.mBuffers[0].mDataByteSize = (UInt32)aacData.length;
    inAudioBufferList.mBuffers[0].mData = (void*)[aacData bytes];
    
    uint32_t bufferSize = inAudioBufferList.mBuffers[0].mDataByteSize;
    uint8_t *buffer = (uint8_t *)malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    AudioBufferList outAudioBufferList;
    outAudioBufferList.mNumberBuffers = 1;
    outAudioBufferList.mBuffers[0].mNumberChannels = inAudioBufferList.mBuffers[0].mNumberChannels;
    outAudioBufferList.mBuffers[0].mDataByteSize = bufferSize;
    outAudioBufferList.mBuffers[0].mData = buffer;
    
    UInt32 ioOutputDataPacketSize = 1024;
    
    OSStatus status = AudioConverterFillComplexBuffer(_aConverter,
                                                      outputDataProc,
                                                      &inAudioBufferList,
                                                      &ioOutputDataPacketSize,
                                                      &outAudioBufferList,
                                                      NULL);
    if (status == noErr){
        NSData *data = [NSData dataWithBytes:outAudioBufferList.mBuffers[0].mData length:outAudioBufferList.mBuffers[0].mDataByteSize];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mhHWAACDecoderOutPutPcmData:)]) {
            [self.delegate mhHWAACDecoderOutPutPcmData:data];
        }
    }else{
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        NSLog(@"音频解码失败---%@",error);
    }
    free(buffer);
}
@end
