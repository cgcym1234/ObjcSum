//
//  TaggingView.h
//  AutolayoutCell
//
//  Created by aron on 2017/5/27.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAbstractView.h"

@class MMLine;
@interface TaggingView : UIView <MMAbstractView>

- (instancetype)initWithFrame:(CGRect)frame lines:(NSArray<MMLine*>*)lines;

@end
