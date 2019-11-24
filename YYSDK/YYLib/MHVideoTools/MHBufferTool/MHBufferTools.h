//
//  MHBufferTools.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/22.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "libyuv.h"


typedef struct{
    NSData * videoData;  //视频data
    int      width;      //视频宽
    int      height;     //视频高
}MHVideoData;

@interface MHBufferTools : NSObject

/** char转NSData */
+(NSData *)charToData:(char *)ar;
/** NSData转char */
+(char *)dataToChar:(NSData *)data;

/**
 将420YpCbCr8BiPlanar(y_uv YUV420SP NV12)格式的视频buffer转换为y_uv格式NSData
 视频buffer只格式支持kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange|kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 @param videoBuffer videoBuffer
 @return 转换后的数据(结构体)
 */
+(MHVideoData)convertVideoBufferToY_UVData:(CVPixelBufferRef)videoBuffer;

/**
 将32BGRA格式视频buffer转为y_uv格式NSData
 buffer只支持kCVPixelFormatType_32BGRA格式
 @param videoBuffer videoBuffer
 @return 转换后的数据(结构体)
 */
+(MHVideoData)convertBGRABufferToY_UVData:(CVPixelBufferRef)videoBuffer;

/**
 将CMSampleBufferRef音频桢转为Pcm NSData
 @param audioSample audioSample
 @return 转换后的pcmData
 */
+(NSData *)convertAudioBufferToPcmData:(CMSampleBufferRef)audioSample;

/**
 将CVPixelBufferRef转为y_u_vData
 注意videoBuffer格式，未做格式判断，理论上只支持420YpCbCr8Planar,其他格式buffer转换后可能丢失颜色数据
 @param videoBuffer videoBuffer
 @return 转换后的数据(结构体)
 */
+(MHVideoData)convertVideoBufferToY_U_VData:(CVPixelBufferRef)videoBuffer;

/**
 将NSData(y_uv)转换为CVPixelBufferRef
 @param y_uvData y_uv数据data
 @param width 视频宽
 @param height 视频高
 @return CVPixelBufferRef
 */
+(CVPixelBufferRef)y_uvDataToBuffer:(NSData *)y_uvData frameWidth:(int)width height:(int)height;

/**
 CVImageBufferRef转换为CGImageRef
 @param imageBuffer CVImageBufferRef
 @return CGImageRef
 */
+(CGImageRef)imageRefFromimageBuffer:(CVImageBufferRef)imageBuffer;

/**
 CVImageBufferRef转换为UIImage
 @param imageBuffer CVImageBufferRef
 @return image
 */
+(UIImage *)imageFromimageBuffer:(CVImageBufferRef)imageBuffer;

/**
 裁剪YUV数据
 @param srcBuffer 原始数据
 @param srcW 原始宽
 @param srcH 原始高
 @param desBuffer 输出数据
 @param x 裁剪x
 @param y 裁剪y
 @param desW 裁剪宽
 @param desH 裁剪高
 */
+(void)cutxYUV420:(char *)srcBuffer srcW:(int)srcW srcH:(int)srcH desBuffer:(char *)desBuffer cutX:(int)x cutY:(int)y cutW:(int)desW cutH:(int)desH;

@end


