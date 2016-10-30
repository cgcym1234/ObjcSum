//
//  UISliderController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UISliderController.h"

@interface UISliderController ()

@end

@implementation UISliderController

- (void)sliderInit
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 100, 200, 20)];
    slider.tag = 101;
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    //    [slider addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    //    [slider addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchDragInside];
    [slider addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchDragOutside];
}

@end
