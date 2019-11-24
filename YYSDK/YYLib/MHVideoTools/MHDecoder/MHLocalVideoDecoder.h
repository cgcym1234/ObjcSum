//
//  MHLocalVideoDecoder.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/28.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol MHLocalVideoDecoderDelegate <NSObject>

@optional
-(void)mhLocalDecoderOutPutVideoBuffer:(CVImageBufferRef)videoBuffer;
-(void)mhLocalDecoderOutPutAudioBuffer:(CMSampleBufferRef)audioBuffer;
@end

@interface MHLocalVideoDecoder : NSObject

@property(nonatomic,weak)id <MHLocalVideoDecoderDelegate> delegate;

@property(nonatomic,strong,readonly)NSURL *url;

@property(assign,nonatomic)BOOL playAtActualSpeed;//是否以视频原始速度播放

- (void)startProcessingVideoUrl:(NSURL *)videoUrl;

@end

