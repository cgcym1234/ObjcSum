//
//  YYAlertTextView.h
//  justice
//
//  Created by sihuan on 15/10/18.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@class YYAlertTextView;

typedef void (^YYAlertTextViewDidClickedBlock)(YYAlertTextView *view, NSInteger buttonIndex);

@interface YYAlertTextView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YYTextView *textView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) YYAlertTextViewDidClickedBlock didClickedBlock;

+ (instancetype)instanceFromNib;
+ (instancetype)show;
- (instancetype)show;


@end
