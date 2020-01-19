//
//  Recorder.m
//  ANTSCMS2_0Demo
//
//  Created by ants-mac on 16/6/1.
//  Copyright © 2016年 www.yurfly.com. All rights reserved.
//




#import "Recorder.h"
#import "AudioFormat.h"
#import <CoreAudio/CoreAudioTypes.h>
const int kQueueBuffersCount = 3;
static const int kMaxFrameSize = 256; /* It muse be pow(2,x) */
@interface Recorder ()
{
    AudioQueueBufferRef     _queueBuffers[kQueueBuffersCount];
    AudioStreamBasicDescription _streamDesc;
    AudioQueueRef               _audioQueue;
}
@end


static void audioQueueInputCallback(void *inUserData,
                                    AudioQueueRef inAQ,
                                    AudioQueueBufferRef inBuffer,
                                    const AudioTimeStamp *inStartTime,
                                    UInt32 inNumberPacketDescriptions,
                                    const AudioStreamPacketDescription *inPacketDescs);



@implementation Recorder

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
    //Set the recording callback function
    AudioQueueNewInput(&_streamDesc, audioQueueInputCallback, (__bridge void *)(self), NULL, kCFRunLoopCommonModes,0, &_audioQueue);
    //Create and allocate buffer space
    for (int i = 0; i < kQueueBuffersCount; i++)
    {
        //Create audio buffer data
        AudioQueueAllocateBuffer(_audioQueue, kMaxFrameSize, &_queueBuffers[i]);
        //The buffer is added to the data arrangement AudioQueueRef wait to play
        AudioQueueEnqueueBuffer(_audioQueue, _queueBuffers[i], 0, NULL);
    }
}

- (void)dealloc
{
    NSLog(@"Recorder Dealloc");
    AudioQueueStop(_audioQueue, true);
    AudioQueueDispose(_audioQueue, true);
}

- (void)start
{
    NSLog(@"record start");
    AudioQueueStart(_audioQueue, NULL);
}

- (void)stop
{
    NSLog(@"record stop");
    AudioQueueStop(_audioQueue, true);
}

- (void)pause
{
    NSLog(@"record pause");
    AudioQueuePause(_audioQueue);
}

@end


//Callback
static void audioQueueInputCallback(void *inUserData,
                                    AudioQueueRef inAQ,
                                    AudioQueueBufferRef inBuffer,
                                    const AudioTimeStamp *inStartTime,
                                    UInt32 inNumberPacketDescriptions,
                                    const AudioStreamPacketDescription *inPacketDescs)
{
    Recorder *recorder = (__bridge Recorder *)inUserData;
    if (inNumberPacketDescriptions > 0)
    {
        if (recorder.bufferCallback) {
            recorder.bufferCallback(inBuffer, inAQ);
        }
    }
    //Reload the buffer inBuffer into the buffer queue inAQ
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

/*
 A Recording Audio Queue includes a Buffer Queue and a Callback
 Recording process
 1. Fill the audio into the first buffer
 2. When the first buffer in the queue is full, the next buffer is automatically populated. At this point, the callback is triggered.
 3. The audio data stream needs to be written to disk in the callback function
 4. Then, you need to reload the buffer into the buffer queue in the callback function to reuse the buffer. Repeat step 2.
 
 */
