//
//  YYScrollSigmentCell.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/27.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYScrollSigment.h"

@interface YYScrollSigmentCell : UICollectionViewCell<YYScrollSigmentCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) NSString *title;

- (void)updateWithItem:(id)item atIndexPath:(NSIndexPath *)indexPath inView:(YYScrollSigment *)view;

@end
