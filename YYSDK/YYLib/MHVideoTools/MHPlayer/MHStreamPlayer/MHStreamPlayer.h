//
//  MHStreamPlayer.h
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/6.
//  Copyright © 2019 mh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>



@interface MHStreamPlayer : UIView

/** 根据frame初始化播放器 */
- (id)initWithFrame:(CGRect)frame;

/**
 输入CVPixelBufferRef数据渲染播放
 @param pixelBuffer CVPixelBufferRef
 */
- (void)inputPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 输入YUV数据渲染播放
 @param yuv yuv数据源
 @param width 原始宽
 @param height 原始高
 */
-(void)inputYuvDataTexture:(char *)yuv width:(int)width height:(int)height;

/**
 输入CGImageRef数据渲染播放
 @param spriteImage CGImageRef数据
 */
- (void)inputCgImageTexture:(CGImageRef)spriteImage;

/**
 输入Rgb数据渲染播放
 @param rgb Rgb数据源
 @param width 原始宽
 @param height 原始高
 */
- (void)inputRgbDataTexture:(const char *)rgb width:(int)width height:(int)height;

/**
 输入Rgba数据渲染播放
 @param rgba rgba数据源
 @param width 原始宽
 @param height 原始高
 */
- (void)inputRgbaDataTexture:(const char *)rgba width:(int)width height:(int)height;


/**
 清除播放器
 */
-(void)cleanPlayer;

@end
