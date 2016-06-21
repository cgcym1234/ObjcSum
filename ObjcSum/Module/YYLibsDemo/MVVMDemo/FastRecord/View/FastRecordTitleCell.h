//
//  FastRecordTitleCell.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecordBaseCell.h"

@interface FastRecordTitleCell : FastRecordBaseCell

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, assign) FastRecordType selectedType;

@end
