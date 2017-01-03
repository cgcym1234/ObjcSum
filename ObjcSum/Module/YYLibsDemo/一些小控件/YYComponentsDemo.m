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
#import "GoodsDetailButton.h"
#import "UIView+Frame.h"

@interface YYComponentsDemo ()

@property (nonatomic, weak) IBOutlet YYLabel *lable;
@property (nonatomic, weak) IBOutlet YYButton *button;
@property (nonatomic, weak) IBOutlet YYRightImageButton *rightImage;


@property (nonatomic, strong) GoodsDetailButton *goodsButton;
@end

@implementation YYComponentsDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lable.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
    
    [_button setImagePosition:YYButtonImagePositionRight spacing:10];
    
    
    GoodsDetailButton *goodsButton = [GoodsDetailButton new];
    goodsButton.text = @"商品详情";
    goodsButton.top = 200;
    goodsButton.left = 20;
    goodsButton.spacing = 3;
    goodsButton.image = [UIImage imageNamed:@"taxPriceDesIcon"];
    goodsButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14);
    goodsButton.borderColor = [UIColor redColor];
    goodsButton.borderWidth = 1;
    [goodsButton sizeToFit];
    _goodsButton = goodsButton;
    [self.view addSubview:goodsButton];
    

    
    MacroWeakSelf(weakSelf);
    [self addButtonWithTitle:@"调整button文字" action:^(UIButton *btn) {
        [weakSelf.button setTitleNormal:@"变长了看看呢"];
        weakSelf.rightImage.text = @"变长了看看呢变长了看看呢";
        weakSelf.goodsButton.text = @"商品详情 商品详情 商品详情";
    }];
    
    [self addButtonWithTitle:@"调整button frame" action:^(UIButton *btn) {
        weakSelf.goodsButton.width = 60;
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
