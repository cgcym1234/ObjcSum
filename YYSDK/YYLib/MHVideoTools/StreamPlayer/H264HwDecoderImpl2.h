//
//  H264HwDecoderImpl2.h
//  SecurityInPalm
//
//  Created by tl on 2018/6/20.
//  Copyright © 2018年 MEye_SecurityInPalm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VideoToolbox/VideoToolbox.h>

typedef NS_ENUM(NSInteger,VideoSteamType) {
    VideoSteamType_Audio = 0,
    VideoSteamType_H264 = 1,
    VideoSteamType_H265 = 2
};

@protocol H264HwDecoderImplDelegate <NSObject>

@optional
- (void)displayDecodedFrame:(CMSampleBufferRef)imageBuffer;

@end

@interface H264HwDecoderImpl2 : NSObject

@property (weak, nonatomic) id<H264HwDecoderImplDelegate> delegate;

- (instancetype)initWithType:(VideoSteamType)type;
- (instancetype)initWithType:(VideoSteamType)type size:(CGSize)size;

- (void)closed;
-(BOOL)initH264Decoder;
-(void)decodeNalu:(uint8_t *)frame withSize:(uint32_t)frameSize;

- (void)saveImageToPath:(NSString *)aPath;
- (void)getSnapshot:(void (^)(UIImage *))handler;

@end
