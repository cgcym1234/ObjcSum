//
//  AudioPlayer.m
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/5/12.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioQueueModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioFormat.h"


static const int kMaxFrameSize = 512; /* It muse be pow(2,x) */
@interface AudioPlayer ()
{
    AudioStreamBasicDescription _streamDesc;
    AudioQueueRef               _audioQueue;
}

@property (strong, atomic) NSMutableArray *buffers;

@end

static void audioQueueOutputCallback(void * inUserData,
                                     AudioQueueRef inAQ,
                                     AudioQueueBufferRef inBuffer);

@implementation AudioPlayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //Initialize the audio data, configure the parameters
        _streamDesc = [AudioFormat defaultFormat];
        [self initialize];
    }
    return self;
}

- (instancetype)initWith:(AudioStreamBasicDescription *)desc
{
    self = [super init];
    if (self) {
        if (NULL == desc) {
            _streamDesc = [AudioFormat defaultFormat];
        } else {
            _streamDesc = *desc;
        }
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _buffers = [NSMutableArray array];
    [self createAudioQueue];
    
    //        AudioQueueReset(_audioQueue);
    
    
    //    Single *sing = [Single shareSingle];
    if (0)
    {
        NSLog(@"for audio");
        //kAudioSessionCategory_Playback----Speaker mode
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    else
    {
        NSLog(@"for intercom");
        //kAudioSessionCategory_PlayAndRecord-------Handset mode
        //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        //AVAudioSessionPortOverrideSpeaker  AVAudioSessionCategoryOptionDefaultToSpeaker
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    //The AudioQueueStart is called in the presence of buffer in the buffer
    //AudioQueue will use Buffer to play the buffer in the column in Enqueue order
    AudioQueueStart(_audioQueue, NULL);
    
}

- (void)dealloc
{
    NSLog(@"Audio Dealloc");
    [self clean];
}

- (AudioQueueModel *)getEmptyQueueBufferModel
{
    AudioQueueModel *model = self.buffers.firstObject;
    
    if (model == nil)
    {
        NSLog(@"Allocate One Buffer");
        AudioQueueBufferRef queueBuffer;
        //After the AudioQueueStart is called , you need to generate several AudioQueueBufferRef structures through the AudioQueueAllocateBuffer, which will be used to store the audio data to be played, and these buffers are managed by their AudioQueue instances
        AudioQueueAllocateBuffer(_audioQueue, kMaxFrameSize, &queueBuffer);
        
        model = [AudioQueueModel modelWith:queueBuffer queue:_audioQueue];
        @synchronized(self)
        {
            [self.buffers addObject:model];
        }
    }
    
    return model;
}

- (BOOL)fillBuffer:(void *)buffer size:(int)size
{
    AudioQueueModel *bufferModel = [self getEmptyQueueBufferModel];
    if (bufferModel != nil)
    {
        
        //1.Audio data needs to be played first when you need to be memcpy to AudioQueueBufferRef in mAudioData
        memcpy(bufferModel.buffer->mAudioData, buffer, size);
        
        //2.Assign the incoming data size to the mAudioDataByteSize field
        bufferModel.buffer->mAudioDataByteSize = size;
        
        @synchronized(self)
        {
            [self.buffers removeObjectAtIndex:0];
        }
        
        //3.Insert the buffer with the audio data into the AudioQueue built-in Buffer queue
        //The buffer is added to the data arrangement AudioQueueRef wait to play
        AudioQueueEnqueueBuffer(bufferModel.queue, bufferModel.buffer, 0, NULL);
        
        return YES;
    }
    return NO;
}

-(void)createAudioQueue
{
    [self clean];
    //Use the internal thread of the player
    //Create an audio queue for playback
    AudioQueueNewOutput(&_streamDesc, audioQueueOutputCallback, (__bridge void *)(self), nil, nil, 0, &_audioQueue);
}

-(void)clean
{
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝clean method");
    if(_audioQueue)
    {
        NSLog(@"Release AudioQueueNewOutput");
        [self stop];
        _audioQueue = nil;
    }
}

-(void)stop
{
    NSLog(@"Audio Player Stop");
    
    //After the call will play all the Enqueu buffer after the reset decoder status
    AudioQueueFlush(_audioQueue);
    //Resetting AudioQueue clears all Enqueue buffers and triggers AudioQueueOutputCallback
    AudioQueueReset(_audioQueue);
    //The second parameter will stop playing (sync) if it is true, and if it is false, the AudioQueue will play all the buffers that have been Enqueue and stop (async)
    AudioQueueStop(_audioQueue, true);
}

- (void)reloadBuffer:(AudioQueueBufferRef) buffer to:(AudioQueueRef)queue
{
    @synchronized(self)
    {
        [self.buffers addObject:[AudioQueueModel modelWith:buffer queue:queue]];
    }
}

@end

//The function of writing audio data to the queue cache is done by the callback
static void audioQueueOutputCallback(void * inUserData,
                                     AudioQueueRef inAQ,
                                     AudioQueueBufferRef inBuffer)
{
    //NSLog(@"audioQueueOutputCallback");
    AudioPlayer *user = (__bridge AudioPlayer *)inUserData;
    [user reloadBuffer:inBuffer to:inAQ];
    memset(inBuffer->mAudioData, 0, inBuffer->mAudioDataByteSize);
    
}

