//
//  YYMessageObjectImage.h
//  ObjcSum
//
//  Created by sihuan on 16/1/21.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageObject.h"
#import "YYMessage.h"

@interface YYMessageObjectImage : NSObject<YYMessageObject>

/**
 *  图片实例对象初始化方法
 *
 *  @param image 要发送的图片
 *
 *  @return 图片实例对象
 */
- (instancetype)initWithImage:(UIImage*)image;

@property (nonatomic, weak) YYMessage *message;

/**
 *  文件展示名
 */
@property (nonatomic, copy) NSString * displayName;

/**
 *  图片本地路径
 */
@property (nonatomic, copy, readonly) NSString * path;

/**
 *  缩略图本地路径
 */
@property (nonatomic, copy, readonly) NSString * thumbPath;

/**
 *  图片远程路径
 */
@property (nonatomic, copy, readonly) NSString * url;

/**
 *  缩略图远程路径
 */
@property (nonatomic, copy, readonly) NSString * thumbUrl;

/**
 *  图片尺寸
 */
@property (nonatomic, assign, readonly) CGSize size;

/**
 *  图片选项
 */
//@property (nonatomic ,strong) NIMImageOption *option;

/**
 *  文件大小
 */
@property (nonatomic, assign, readonly) long long fileLength;

@end
