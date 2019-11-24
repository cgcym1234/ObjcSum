//
//  MHCVPixelBuffer.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/22.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import "libyuv.h"

/** CVPixelBuffer格式转换 裁剪 旋转 */
@interface MHCVPixelBuffer : NSObject

/**
 将CVPixelBufferRef转为Y_UV格式buffer
 只支持32BGRA(bgra)，420YpCbCr8Planar(i420)
 @param pixelBuffer 源buffer
 @return 转换后的buffer(nv12 Y_UV格式)
 */
+(CVPixelBufferRef)convertBufferToY_UV:(CVPixelBufferRef)pixelBuffer;

/**
 裁剪CVPixelBufferRef
 @param sourcePixelBuffer 要裁剪的CVPixelBufferRef
 @param scaledSize 裁剪大小
 @return 裁剪后的CVPixelBufferRef
 */
+(CVPixelBufferRef)cropPixelBuffer:(CVPixelBufferRef)sourcePixelBuffer scaledSize:(CGSize)scaledSize;

/*
 * 注意旋转SampleBuffer 为argb或者bgra格式，其他格式可能不支持
 * rotationConstant:
 *  0 -- rotate 0 degrees (simply copy the data from src to dest)
 *  1 -- rotate 90 degrees counterclockwise
 *  2 -- rotate 180 degress
 *  3 -- rotate 270 degrees counterclockwise
 */
+ (CVPixelBufferRef)rotateBuffer:(CVImageBufferRef)sampleBuffer withConstant:(uint8_t)rotationConstant;


@end

