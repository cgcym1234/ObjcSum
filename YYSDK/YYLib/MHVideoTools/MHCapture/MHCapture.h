//
//  MHCapture.h
//  MHVideoEDecoder
//
//  Created by mahao on 2019/5/20.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MHFilter.h"//GPUImage
#import "MHGPUImageVideoCamera.h"

typedef enum : NSUInteger {
    MHAVCaptureTypeNone,
    MHAVCaptureTypeSystem,
    MHAVCaptureTypeGPUImage,
} MHAVCaptureType;

@protocol MHCaptureDelegate;

@interface MHCapture : NSObject

/** 状态变化回调代理 */
@property(nonatomic,weak)id <MHCaptureDelegate> delegate;
/** 视频捕获类型 */
@property(nonatomic,assign,readonly)MHAVCaptureType captureType;
/** 视频分辨率 */
@property(nonatomic,copy,readonly)AVCaptureSessionPreset sessionPreset;
/** 视频帧率 */
@property(nonatomic,assign,readonly)NSInteger minFrameRate;
/** 是否已经在采集 */
@property(nonatomic,assign,readonly)BOOL isCapturing;
/** 预览view */
@property(nonatomic,strong,readonly)UIView * preview;
/** 预览图层frame */
@property(nonatomic,assign)CGRect preViewRect;

/**
 初始化
 @param captureType 视频捕获类型
 @param sessionPreset 分辨率
 @param preViewRect 预览图层frame
 @return capture
 */
-(instancetype)initWithCaptureType:(MHAVCaptureType)captureType sessionPreset:(AVCaptureSessionPreset)sessionPreset preViewRect:(CGRect)preViewRect;

/**
 开始采集
 */
-(void)startCapture;

/**
 停止采集
 */
-(void)stopCapture;

/**
 切换前后摄像头
 */
-(void)switchCamera;

/**
 采集过程中动态修改视频分辨率
 @param sessionPreset 分辨率
 */
- (void)changeSessionPreset:(AVCaptureSessionPreset)sessionPreset;

/**
 设置帧率
 @param minFrameRate 最小帧率
 */
-(void)changeFrameRate:(NSInteger)minFrameRate;

@end


@protocol MHCaptureDelegate <NSObject>

@optional
-(void)mhCaptureSendVideoBuffer:(CVImageBufferRef)videoBuffer;
-(void)mhCaptureSendAudioBuffer:(CMSampleBufferRef)audioBuffer;

@end
