//
//  YYMessageMoreViewCell.m
//  ObjcSum
//
//  Created by sihuan on 16/2/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageMoreViewCell.h"

@implementation YYMessageMoreViewCellModel

//[YYMessageMoreViewCellModel modelWithText:@"照片" imageName:@"ChatWindow_Photo"],
//[YYMessageMoreViewCellModel modelWithText:@"拍照" imageName:@"ChatWindow_Camera"]
- (void)setType:(YYMessageMoreViewItem)type {
    _type = type;
    switch (type) {
        case YYMessageMoreViewItemCamera: {
            _text = @"照片";
            _imageName = @"ChatWindow_Photo";
            break;
        }
        case YYMessageMoreViewItemAlbum: {
            _text = @"拍照";
            _imageName = @"ChatWindow_Camera";
            break;
        }
    }
}

+ (instancetype)modelWithType:(YYMessageMoreViewItem)type {
    YYMessageMoreViewCellModel *model = [YYMessageMoreViewCellModel new];
    model.type = type;
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
