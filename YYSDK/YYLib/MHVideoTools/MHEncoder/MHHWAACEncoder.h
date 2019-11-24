//
//  MHHWAACEncoder.h
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/21.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface MHHWAACEncoderParam : NSObject
/** 码率 默认100000 */
@property (nonatomic, assign) NSInteger bitrate;
/** 声道数 默认1单声道 */
@property (nonatomic, assign) NSInteger channelCount;
/** 采样率 默认44100 */
@property (nonatomic, assign) NSInteger sampleRate;

@end

@protocol MHHWAACEncoderDelegate <NSObject>

@optional
-(void)mhHWAACEncoderOutputData:(NSData *)aacData;

@end

/* AAC硬编码器 */
@interface MHHWAACEncoder : NSObject

@property(nonatomic,weak)id <MHHWAACEncoderDelegate> delegate;

/** 编码参数 */
@property (nonatomic,strong,readonly)MHHWAACEncoderParam * param;

//初始化
-(instancetype)initWithParam:(MHHWAACEncoderParam *)param;

- (void)audioEncodeInpuBuffer:(CMSampleBufferRef)sampleBuffer;

@end


