//
//  FlexboxDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2018/3/28.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "FlexboxDemo.h"
#import "FlexBoxLayout.h"
#import "FBAsyLayoutTransaction.h"

@interface FlexboxDemo ()

@end

@implementation FlexboxDemo

- (void)viewDidLoad {
    [super viewDidLoad];
	[self test1];
}

- (void)test1 {
	UIView *v1 = [UIView new];
	v1.backgroundColor = [UIColor blueColor];
	[v1 fb_makeLayout:^(FBLayout *layout) {
		layout.width.height.equalTo(@100);
	}];
	
	UIView *v2 = [UIView new];
	v2.backgroundColor = [UIColor greenColor];
	[v2 fb_makeLayout:^(FBLayout *layout) {
		layout.equalTo(v1);
	}];
	
	UILabel *lable = [UILabel new];
	lable.numberOfLines = 0;
	lable.backgroundColor = [UIColor yellowColor];
	[lable fb_wrapContent];
	[lable setAttributedText:[[NSAttributedString alloc] initWithString:@"testfdsfdsfdsfdsfdsfdsafdsafdsafasdkkk" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]}] ];
	
	[self.view addSubview:v1];
	[self.view addSubview:v2];
	[self.view addSubview:lable];
	
//	FBLayoutDiv *div1 = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn justifyContent:FBJustifySpaceBetween alignItems:FBAlignCenter children:@[v1,v2,lable]];
//	[div1 fb_makeLayout:^(FBLayout *layout) {
//		layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(20, 0, 0, 0));
//		layout.width.equalTo(@(150));
//	}];
	
	[self.view fb_makeLayout:^(FBLayout *layout) {
		layout.flexDirection.equalTo(@(FBFlexDirectionColumn))
		.justifyContent.equalTo(@(FBJustifySpaceBetween))
		.children(@[v1,v2,lable]);
	}];
}


@end

















