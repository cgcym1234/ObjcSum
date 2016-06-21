//
//  YYThumbnailItem.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYThumbnailItem.h"

@implementation YYThumbnailItem

// Class
+ (instancetype)itemWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}
+ (instancetype)itemWithUrl:(NSURL *)url {
    return [[self alloc] initWithUrl:url];
}

+ (NSArray *)itemsWithImages:(NSArray *)imagesArray {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:imagesArray.count];
    
    for (UIImage *image in imagesArray) {
        if ([image isKindOfClass:[UIImage class]]) {
            [items addObject:[[self alloc] initWithImage:image]];
        }
    }
    
    return items;
}
+ (NSArray *)itemsWithUrls:(NSArray *)urlsArray {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:urlsArray.count];
    
    for (id url in urlsArray) {
        if ([url isKindOfClass:[NSURL class]]) {
            [items addObject:[[self alloc] initWithUrl:url]];
        }
    }
    
    return items;
}

// Init
- (instancetype)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        self.thumbImage = image;
    }
    return self;
}
- (instancetype)initWithUrl:(NSURL *)url {
    if ((self = [super init])) {
        self.thumbUrl = [url copy];
    }
    return self;
}

@end
