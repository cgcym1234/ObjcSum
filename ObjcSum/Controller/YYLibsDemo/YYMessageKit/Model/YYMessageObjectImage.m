//
//  YYMessageObjectImage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageObjectImage.h"
#import "UIImage+YYMessage.h"

@interface YYMessageObjectImage ()

@property (nonatomic, copy) NSString * path;
@property (nonatomic, copy) NSString * thumbPath;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * thumbUrl;
@property (nonatomic, assign) CGSize size;
//@property (nonatomic ,strong) NIMImageOption *option;
@property (nonatomic, assign) long long fileLength;

@end
@implementation YYMessageObjectImage

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _thumbPath = [image saveToDiskAsThumbnail];
    }
    return self;
}


- (YYMessageType)type {
    return self.message.messageType;
}

@end
