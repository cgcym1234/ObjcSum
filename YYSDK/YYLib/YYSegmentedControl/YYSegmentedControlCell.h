//
//  YYSegmentedControlCell.h
//  MLLSalesAssistant
//
//  Created by sihuan on 16/3/16.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSegmentedControl.h"

@interface YYSegmentedControlCell : UICollectionViewCell
<YYSegmentedControlItem>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)renderWithItem:(id)item atIndex:(NSInteger)index inSegmentControl:(YYSegmentedControl *)segmenteControl;

@end
