//
//  YYImageBrowserCell.h
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYImageBrowser.h"
#import "YYImageBrowserScrollView.h"

@class YYImageBrowserCell;

@protocol YYImageBrowserCellDelegate <NSObject>

@optional
- (void)imageBrowserCellDidTap:(YYImageBrowserCell *)cell;

@end

@interface YYImageBrowserCell : UICollectionViewCell<YYImageBrowserScrollViewDelegate>

@property (nonatomic, weak) id <YYImageBrowserCellDelegate> delegate;
@property (strong, nonatomic) YYImageBrowserScrollView *imageScroll;

- (void)updateWithItem:(YYImageBrowserItemModel *)item
        inImageBrowser:(YYImageBrowser *)browser
           atIndexPath:(NSIndexPath *)indexPath;

@end
