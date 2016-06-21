//
//  FastRecordClockCell.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/29.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecordBaseCell.h"


@interface FastRecordClockCell : FastRecordBaseCell
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *clockButton;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;

@property (nonatomic, copy) NSString *text;


@end
