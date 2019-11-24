//
//  MHHWH264Encoder.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/23.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface MHHWH264EncoderParam : NSObject

/** 编码内容的宽度  默认480*/
@property (nonatomic, assign) NSInteger encodeWidth;
/** 编码内容的高度  默认640*/
@property (nonatomic, assign) NSInteger encodeHeight;
/** 码率 单位kbps 默认1024 * 1024*/
@property (nonatomic, assign) NSInteger bitRate;
/** 帧率 单位为fps，默认为30fps */
@property (nonatomic, assign) NSInteger frameRate;
/** 最大I帧间隔，单位为秒，默认为10秒一个I帧 */
@property (nonatomic, assign) NSInteger maxKeyFrameInterval;

@end

@protocol MHHWH264EncoderDelegate <NSObject>

@optional
/**
 编码输出数据
 @param data 输出数据
 @param isKeyFrame 是否为关键帧
 */
- (void)mhHWH264EncoderOutputData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame;

@end

@interface MHHWH264Encoder : NSObject

@property (nonatomic, weak) id<MHHWH264EncoderDelegate> delegate;

/** 编码参数 */
@property (nonatomic,strong,readonly)MHHWH264EncoderParam * param;

//初始化
-(instancetype)initWithParam:(MHHWH264EncoderParam *)param;

/**
 停止编码
 @return 成功/失败
 */
- (BOOL)stopVideoEncode;

/**
 输入待编码数据
 @param sampleBuffer 待编码数据
 */
- (void)videoEncodeInputBuffer:(CVImageBufferRef)sampleBuffer;


@end

