//
//  YYMessageMoreViewCell.h
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHorizontalScrollViewCell.h"

@interface YYMessageMoreViewCellModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *text;

+ (instancetype)modelWithText:(NSString *)text imageName:(NSString *)imageName;

@end

@interface YYMessageMoreViewCell : UICollectionViewCell<YYHorizontalScrollViewCell>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
