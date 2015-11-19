//
//  UITableViewCell+CustomSetting.h
//  ObjcSum
//
//  Created by sihuan on 15/11/18.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CustomSetting)

#pragma mark - 设置layoutMargins为UIEdgeInsetsZero，方便自定义分隔线长度
- (UIEdgeInsets)layoutMargins;

@end
