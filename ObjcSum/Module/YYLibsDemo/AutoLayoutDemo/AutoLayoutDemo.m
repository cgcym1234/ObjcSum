//
//  AutoLayoutDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "AutoLayoutDemo.h"
#import "HeaderMacroCommon.h"
#import "UIViewController+Extension.h"

@interface AutoLayoutDemo ()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLeftToLeftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLeftToView;

@end

@implementation AutoLayoutDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"隐藏左边按钮" action:^(UIButton *btn) {
        weakSelf.leftLabel.text = @"";
//        weakSelf.leftLabel.attributedText =  [[NSMutableAttributedString alloc] initWithString:nil];
        CGSize size =  weakSelf.leftLabel.intrinsicContentSize;
        [weakSelf setLeftLabelHidden:weakSelf.leftLabel.text.length == 0];
    }];
}

- (void)setLeftLabelHidden:(BOOL)hidden {
    _marginLeftToLeftLabel.priority = hidden ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh;
    
    _marginLeftToView.priority = hidden ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
