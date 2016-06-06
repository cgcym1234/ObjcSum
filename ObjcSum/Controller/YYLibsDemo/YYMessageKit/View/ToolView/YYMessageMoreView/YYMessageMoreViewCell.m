//
//  YYMessageMoreViewCell.m
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageMoreViewCell.h"

@implementation YYMessageMoreViewCellModel

+ (instancetype)modelWithText:(NSString *)text imageName:(NSString *)imageName {
    YYMessageMoreViewCellModel *model = [YYMessageMoreViewCellModel new];
    model.text = text;
    model.imageName = imageName;
    return model;
}

@end

@implementation YYMessageMoreViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (NSString *)xibName {
    return NSStringFromClass(self.class);
}

- (void)renderWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inView:(YYHorizontalScrollView *)view {
    YYMessageMoreViewCellModel *item = model;
    _label.text = item.text;
    _imageView.image = [UIImage imageNamed:item.imageName];
}


@end
