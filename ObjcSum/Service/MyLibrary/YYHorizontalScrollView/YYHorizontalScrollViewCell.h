//
//  YYHorizontalScrollViewCell.h
//  ObjcSum
//
//  Created by sihuan on 16/6/3.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#ifndef YYHorizontalScrollViewCell_h
#define YYHorizontalScrollViewCell_h

@class YYHorizontalScrollView;
//配置cell的协议,自定义item时候必须实现
@protocol YYHorizontalScrollViewCell

@required

+ (NSString *)xibName;
+ (NSString *)identifier;

//配置cell
- (void)renderWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inView:(YYHorizontalScrollView *)view;


@end

#endif /* YYHorizontalScrollViewCell_h */
