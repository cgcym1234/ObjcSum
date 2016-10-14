//
//  YYImageBrowserScrollView.m
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import "YYImageBrowserScrollView.h"
#import "UIImageView+Extension.h"
#import "YYImageBrowser.h"
#import "UIImage+YYSDK.h"


#define PlaceHolderImage @"375x248"

#define ScaleMax 2
#define ScaleMin 1

@interface YYImageBrowserScrollView ()
<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end


@implementation YYImageBrowserScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    self.delegate = self;
    self.bounces = YES;
    self.alwaysBounceHorizontal = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.maximumZoomScale = ScaleMax;
    self.minimumZoomScale = ScaleMin;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTapGesture:)];
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.delegate = self;
    [imageView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleTapGesture:)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTouchesRequired = 1;
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self addGestureRecognizer:singleTapGesture];
    
    [self addSubview:imageView];
    _imageView = imageView;
}


- (void)updateWithItem:(YYImageBrowserItemModel *)item {
    [self setImageViewWithImage:[UIImage imageNamed:PlaceHolderImage]];
    __weak typeof(self) weakSelf = self;
    if (item.smallImageUrl) {
        [_imageView setImageWithURLStr:item.smallImageUrl placeholderImage:[UIImage imageNamed:PlaceHolderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf setImageViewWithImage:image];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf.imageView setImageWithURLStr:item.bigImageUrl placeholderImage:image ?: [UIImage imageNamed:PlaceHolderImage] completed:^(UIImage *bigImage, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf setImageViewWithImage:bigImage];
                }];
            });
            
        }];
    } else {
        [_imageView setImageWithURLStr:item.bigImageUrl placeholderImage:[UIImage imageNamed:PlaceHolderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf setImageViewWithImage:image];
        }];
    }
    
}


- (void)setImageViewWithImage:(UIImage *)image {
    
    if (!image) {
        return;
    }
    
    if (self.zoomScale != 1.0f) {
        [self setZoomScale:1.0f animated:NO];
    }
    
    CGSize fitSize = [image fitSizeInView:self];
    
    self.imageView.bounds = CGRectMake(0,
                                       0,
                                       fitSize.width,
                                       fitSize.height);
    self.imageView.center = self.center;
    
    self.contentSize = CGSizeMake(fitSize.width, fitSize.height);
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX =
    (self.bounds.size.width > self.contentSize.width) ?
    (self.bounds.size.width - self.contentSize.width) * 0.5f : 0.0f;
    
    CGFloat offsetY =
    (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5f : 0.0f;
    
    self.imageView.center = CGPointMake(self.contentSize.width * 0.5f + offsetX,
                                        self.contentSize.height * 0.5f + offsetY);
}

#pragma mark - UITapGestureRecognizer
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    NSInteger numberOfTapsRequired = tapGesture.numberOfTapsRequired;
    
    //双击
    if (numberOfTapsRequired == 2) {
        CGFloat zoomScale = self.zoomScale;
        
        if(zoomScale <= 1.0f){
            CGPoint loc = [tapGesture locationInView:tapGesture.view];
            [self zoomToRect:CGRectMake(loc.x, loc.y, 1, 1) animated:YES];
        }else{
            [self setZoomScale:1.0f animated:YES];
        }
    } else if (numberOfTapsRequired == 1) {
        if ([_imageDelegate respondsToSelector:@selector(imageBrowserScrollViewSingleTap:)]) {
            [_imageDelegate imageBrowserScrollViewSingleTap:self];
        }
    }
}

@end
