//
//  MHHWH264Decoder.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/23.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol MHHWH264DecoderDelegate <NSObject>

@optional
/** H264解码数据回调 */
-(void)mhHWH264DecoderOuPutY_uvPixel:(CVPixelBufferRef)pixelBuffer;
-(void)mhHWH264DecoderOutPutImageref:(CGImageRef)imageref;
-(void)mhHWH264DecoderOuPutY_U_VData:(NSData *)yuvData frameWidth:(int)width height:(int)height;
@end

typedef enum : NSUInteger {
    MHHWH264DecoderOutPutType_y_uv          = 0,
    MHHWH264DecoderOutPutType_y_u_v         = 1,
    MHHWH264DecoderOutPutType_imageref      = 2,
}MHHWH264DecoderOutPutType;//输出视频格式

@interface MHHWH264Decoder : NSObject

@property(nonatomic,weak)id<MHHWH264DecoderDelegate> delegate;

@property (nonatomic,assign)MHHWH264DecoderOutPutType outPutType;    //解码后回调类型

/**
 H264视频流解码
 @param videoData 视频帧数据
 */
- (void)decodeH264VideoData:(NSData *)videoData;
- (void)decodeH264VideoData:(uint8_t *)frame videoSize:(uint32_t)videoSize;

/**
 释放解码器
 */
-(void)releaseH264Decoder;

@end

