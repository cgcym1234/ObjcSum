//
//  ShowRoomCell.m
//  ObjcSum
//
//  Created by sihuan on 16/3/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ShowRoomCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ShowRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateUI:(ShowRoomCellModel *)item {
    _title.text = [NSString stringWithFormat:@"%@(%@市%@)%@", item.houseName, item.cityName, item.districtName, item.ybjStyle];
    _desc.text = item.designeDesc;
    _image.image = [UIImage imageNamed:@"demo_avatar_cook"];
//    [_image setImageWithURLStr:imageUrl placeholderImage:[UIImage imageNamed:ShowRoomDefault]];
}

@end
