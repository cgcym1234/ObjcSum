//
//  YYImageBrowserCell.m
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import "YYImageBrowserCell.h"

@implementation YYImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    YYImageBrowserScrollView *imageScroll = [[YYImageBrowserScrollView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:imageScroll];
    _imageScroll = imageScroll;
}

- (void)updateWithItem:(YYImageBrowserItemModel *)item
        inImageBrowser:(YYImageBrowser *)browser
           atIndexPath:(NSIndexPath *)indexPath {
    _imageScroll.frame = self.bounds;
    _imageScroll.imageDelegate = self;
    [_imageScroll updateWithItem:item];
}

- (void)imageBrowserScrollViewSingleTap:(YYImageBrowserScrollView *)scroll {
    if ([_delegate respondsToSelector:@selector(imageBrowserCellDidTap:)]) {
        [_delegate imageBrowserCellDidTap:self];
    }
}

@end
