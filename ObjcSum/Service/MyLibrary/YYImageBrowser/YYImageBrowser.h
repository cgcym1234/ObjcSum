//
//  YYImageBrowser.h
//  MLLCustomer
//
//  Created by sihuan on 2016/8/15.
//  Copyright © 2016年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCountLabel.h"

@interface YYImageBrowserItemModel: NSObject

@property (nonatomic, copy) NSString *bigImageUrl;
@property (nonatomic, copy) NSString *smallImageUrl;

+ (instancetype)instanceWithBigImageUrl:(NSString *)bigImageUrl smallImageUrl:(NSString *)smallImageUrl;

@end


@class YYImageBrowser;
@protocol YYImageBrowserDelegate <NSObject>

@optional
- (void)imageBrowser:(YYImageBrowser *)brower didShowPhotoAtIndex:(NSUInteger)index;
- (void)imageBrowser:(YYImageBrowser *)brower willDismissAtIndex:(NSInteger)index;


@end

@interface YYImageBrowser : UIViewController

@property (nonatomic, weak) id <YYImageBrowserDelegate> delegate;

//默认0
@property (nonatomic, assign) NSInteger showPage;
@property (nonatomic, assign, readonly) NSInteger totalPages;

@property (nonatomic, assign) CGFloat itemSpacing;

//存放数据源的数组，图片url
@property(nonatomic, copy) NSArray<YYImageBrowserItemModel *> *dataArr;
@property (nonatomic, strong) UIImageView *animatingImageView;

@property (nonatomic, strong) YYCountLabel *countLabel;


- (instancetype)initWithPhotoUrlStrings:(NSArray *)photoUrlStrings;

- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

- (UIScrollView *)innerScrollView;

@end
