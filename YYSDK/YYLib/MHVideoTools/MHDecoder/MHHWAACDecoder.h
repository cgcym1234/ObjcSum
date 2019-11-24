//
//  MHHWAACDecoder.h
//  MHVideoTool
//
//  Created by mahao on 2019/5/28.
//  Copyright © 2019 mh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol MHHWAACDecoderDelegate <NSObject>

@optional
-(void)mhHWAACDecoderOutPutPcmData:(NSData *)pcmData;

@end

@interface MHHWAACDecoder : NSObject

@property(nonatomic,weak)id <MHHWAACDecoderDelegate> delegate;

- (void)audioDecodeAACData:(NSData *)aacData;

@end

