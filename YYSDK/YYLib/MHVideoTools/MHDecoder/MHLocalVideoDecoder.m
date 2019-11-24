//
//  MHLocalVideoDecoder.m
//  MHVideoTool
//
//  Created by mahao on 2019/5/28.
//  Copyright © 2019 mh. All rights reserved.
//

#import "MHLocalVideoDecoder.h"

@interface MHLocalVideoDecoder ()
{
    CMTime previousFrameTime;
    CFAbsoluteTime previousActualFrameTime;
    
    CMTime processingFrameTime;
    
    AVAssetReader * reader;
    
    BOOL audioEncodingIsFinished;
    BOOL videoEncodingIsFinished;
}
@property(readwrite,strong)AVAsset *asset;

@end

@implementation MHLocalVideoDecoder

-(void)dealloc
{
    if (reader) {
        [reader cancelReading];
        reader = nil;
    }
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.playAtActualSpeed = YES;
    }
    return self;
}
- (void)startProcessingVideoUrl:(NSURL *)videoUrl
{
    _url = videoUrl;
    
    previousFrameTime = kCMTimeZero;
    previousActualFrameTime = CFAbsoluteTimeGetCurrent();
    
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:self.url options:inputOptions];
    
    MHLocalVideoDecoder __block *blockSelf = self;
    
    [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
            if (tracksStatus != AVKeyValueStatusLoaded) {
                return;
            }
            blockSelf.asset = inputAsset;
            [blockSelf processAsset];
            blockSelf = nil;
        });
    }];
}
-(void)processAsset
{
    reader = [self createAssetReader];
    
    AVAssetReaderOutput *readerVideoTrackOutput = nil;
    AVAssetReaderOutput *readerAudioTrackOutput = nil;
    
    audioEncodingIsFinished = YES;
    for( AVAssetReaderOutput *output in reader.outputs ) {
        if( [output.mediaType isEqualToString:AVMediaTypeAudio] ) {
            audioEncodingIsFinished = NO;
            readerAudioTrackOutput = output;
        }
        else if( [output.mediaType isEqualToString:AVMediaTypeVideo] ) {
            readerVideoTrackOutput = output;
        }
    }
    
    if ([reader startReading] == NO) {
        NSLog(@"Error reading from file at URL: %@", self.url);
        return;
    }
    
    __unsafe_unretained MHLocalVideoDecoder *weakSelf = self;
    while (reader.status == AVAssetReaderStatusReading) {
        [weakSelf readNextVideoFrameFromOutput:readerVideoTrackOutput];
        
        if ( (readerAudioTrackOutput) && (!audioEncodingIsFinished) )
        {
            [weakSelf readNextAudioSampleFromOutput:readerAudioTrackOutput];
        }
        
    }
    
    if (reader.status == AVAssetReaderStatusCompleted) {
        [reader cancelReading];
    }
}
//创建AVAssetReader
-(AVAssetReader*)createAssetReader
{
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:self.asset error:&error];
    
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    //[outputSettings setObject:@(kCVPixelFormatType_32BGRA) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // Maybe set alwaysCopiesSampleData to NO on iOS 5.0 for faster video decoding
    AVAssetReaderTrackOutput *readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:outputSettings];
    readerVideoTrackOutput.alwaysCopiesSampleData = NO;
    [assetReader addOutput:readerVideoTrackOutput];
    
    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
    
    BOOL shouldRecordAudioTrack = [audioTracks count] > 0;
    
    AVAssetReaderTrackOutput *readerAudioTrackOutput = nil;
    
    if (shouldRecordAudioTrack) {
        // This might need to be extended to handle movies with more than one audio track
        AVAssetTrack* audioTrack = [audioTracks objectAtIndex:0];
        //读取配置
        NSDictionary *dic   = @{AVFormatIDKey            :@(kAudioFormatLinearPCM),
                                AVLinearPCMIsBigEndianKey:@NO,
                                AVLinearPCMIsFloatKey    :@NO,
                                AVLinearPCMBitDepthKey   :@(16)
                                };
        readerAudioTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:dic];
        readerAudioTrackOutput.alwaysCopiesSampleData = NO;
        [assetReader addOutput:readerAudioTrackOutput];
    }
    return assetReader;
}
//读取视频数据
- (void)readNextVideoFrameFromOutput:(AVAssetReaderOutput *)readerVideoTrackOutput
{
    if (reader.status == AVAssetReaderStatusReading && ! videoEncodingIsFinished) {
        CMSampleBufferRef sampleBufferRef = [readerVideoTrackOutput copyNextSampleBuffer];
        if (sampleBufferRef) {
            
            if (self.playAtActualSpeed)
            {
                // Do this outside of the video processing queue to not slow that down while waiting
                CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBufferRef);
                CMTime differenceFromLastFrame = CMTimeSubtract(currentSampleTime, previousFrameTime);
                CFAbsoluteTime currentActualTime = CFAbsoluteTimeGetCurrent();
                
                CGFloat frameTimeDifference = CMTimeGetSeconds(differenceFromLastFrame);
                CGFloat actualTimeDifference = currentActualTime - previousActualFrameTime;
                
                if (frameTimeDifference > actualTimeDifference)
                {
                    usleep(1000000.0 * (frameTimeDifference - actualTimeDifference));
                }
                
                previousFrameTime = currentSampleTime;
                previousActualFrameTime = CFAbsoluteTimeGetCurrent();
            }
            
            [self processMovieFrame:sampleBufferRef];
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
    }
}
//读取音频数据
- (void)readNextAudioSampleFromOutput:(AVAssetReaderOutput *)readerAudioTrackOutput
{
    if (reader.status == AVAssetReaderStatusReading && ! audioEncodingIsFinished)
    {
        CMSampleBufferRef sampleBuffer = [readerAudioTrackOutput copyNextSampleBuffer];
        if (sampleBuffer) {
            
            [self processAudioBuffer:sampleBuffer];
            
            CMSampleBufferInvalidate(sampleBuffer);  //销毁
            CFRelease(sampleBuffer);
        }
    }
}
//处理视频数据
- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer
{
    //CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(movieSampleBuffer);
    CVImageBufferRef movieFrame = CMSampleBufferGetImageBuffer(movieSampleBuffer);
    //NSLog(@"videoTime--->%f",CMTimeGetSeconds(currentSampleTime));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mhLocalDecoderOutPutVideoBuffer:)]) {
//        // retain再输出，外层去release
//        CVPixelBufferRetain(movieFrame);
        [self.delegate mhLocalDecoderOutPutVideoBuffer:movieFrame];
    }
}
//处理音频数据
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mhLocalDecoderOutPutAudioBuffer:)]) {
        [self.delegate mhLocalDecoderOutPutAudioBuffer:audioBuffer];
    }
    // CMBlockBufferRef blockBUfferRef = CMSampleBufferGetDataBuffer(audioBuffer);//取出数据
    // size_t length = CMBlockBufferGetDataLength(blockBUfferRef);//返回一个大小，size_t针对不同的品台有不同的实现，扩展性更好
    // SInt16 sampleBytes[length];
    // CMBlockBufferCopyDataBytes(blockBUfferRef, 0, length, sampleBytes);//将数据放入数组
    // [self.audioData appendBytes:sampleBytes length:length];//将数据附加到data中
}

@end
