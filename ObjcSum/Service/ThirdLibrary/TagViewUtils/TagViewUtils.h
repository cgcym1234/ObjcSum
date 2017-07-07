//
//  TagViewUtils.h
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TagViewUtils : NSObject

+ (void)recursiveSetBorderWithView:(UIView*)view;
+ (void)recursiveShowTagWithView:(UIView*)view;
+ (void)showTaggingViewWithView:(UIView*)view;

@end
