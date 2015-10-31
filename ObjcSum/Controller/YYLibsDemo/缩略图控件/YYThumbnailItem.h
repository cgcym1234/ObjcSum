//
//  YYThumbnailItem.h
//  MySimpleFrame
//
//  Created by sihuan on 15/9/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYThumbnailItem : NSObject

//图像数据，如果为空，使用thumbUrl的数据
@property (nonatomic, strong) UIImage *thumbImage;

//图像资源，可以是网络或者本地资源
@property (nonatomic, strong) NSURL *thumbUrl;

//图像描述
@property (nonatomic, copy) NSString *thumbDesc;

// Class
+ (instancetype)itemWithImage:(UIImage *)image;
+ (instancetype)itemWithUrl:(NSURL *)url;

+ (NSArray *)itemsWithImages:(NSArray *)imagesArray;
+ (NSArray *)itemsWithUrls:(NSArray *)urlsArray;

// Init
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithUrl:(NSURL *)url;

@end
