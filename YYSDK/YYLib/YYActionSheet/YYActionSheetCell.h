//
//  YYActionSheetCell.h
//  ObjcSum
//
//  Created by yangyuan on 2017/6/7.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBLACKTEXTCOLOR [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1]
#define kGRAYTEXTCOLOR [UIColor colorWithRed:192/255.0 green:191/255.0 blue:191/255.0 alpha:1]
#define kREDTEXTCOLOR [UIColor colorWithRed:241/255.0 green:91/255.0 blue:80/255.0 alpha:1]
#define kORANGETEXTCOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:8/255.0 alpha:1]
#define kWHITETEXTCOLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define kINCOMECOLOR [UIColor colorWithRed:48/255.0 green:169/255.0 blue:160/255.0 alpha:1]

@interface YYActionSheetItem : NSObject

@property (nonatomic, copy) NSString *title;

/// 默认黑色
@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)instanceWithTitle:(NSString *)title;

@end



@interface YYActionSheetCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) YYActionSheetItem *model;


@end
