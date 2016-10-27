//
//  YYComponentsDemo.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYComponentsDemo.h"
#import "UIViewController+Extension.h"
#import "YYLabel.h"
#import "YYButton.h"
#import "YYRightImageButton.h"
#import "UIButton+YYSDK.h"

@interface YYComponentsDemo ()

@property (nonatomic, weak) IBOutlet YYLabel *lable;
@property (nonatomic, weak) IBOutlet YYButton *button;
@property (nonatomic, weak) IBOutlet YYRightImageButton *rightImage;

@end

@implementation YYComponentsDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lable.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
    
    [_button setImagePosition:YYButtonImagePositionRight spacing:10];
//    [_button layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:10];
    
    MacroWeakSelf(weakSelf);
    [self addButtonWithTitle:@"调整button文字" action:^(UIButton *btn) {
        [weakSelf.button setTitleNormal:@"变长了看看呢"];
        weakSelf.rightImage.text = @"变长了看看呢变长了看看呢";
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
