//
//  SmallViewsController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/1.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "SmallViewsController.h"
#import "UIViewController+Extension.h"

@interface SmallViewsController ()

@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISwitch *switchV;

@end

@implementation SmallViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.progress];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.switchV];
    
    __weak __typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"dismiss" action:^(UIButton *btn) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - UISegmentedControl
- (UISegmentedControl *)segment {
    if (!_segment) {
        
        NSArray *images = @[[UIImage imageNamed:@"segment_check"], [UIImage imageNamed:@"segment_search"], [UIImage imageNamed:@"segment_tools"]];
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:images];
        //segment.segmentedControlStyle = UISegmentedControlStylePlain;
        segment.frame = CGRectMake(60, 100, 200, 40);
        segment.selectedSegmentIndex = 1;
        //    sc.tintColor = [UIColor redColor];
        [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        _segment = segment;
    }
    return _segment;
}

- (void)change:(UISegmentedControl *)sc
{
    NSLog(@"sc : %li", (long)sc.selectedSegmentIndex);
}

#pragma mark - UIProgressView
- (UIProgressView *)progress {
    if (!_progress) {
        //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，几乎无区别
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        
        //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
        //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
        _progress.frame=CGRectMake(30, 30, 200, 50);
        
        //设置进度条颜色
        _progress.trackTintColor=[UIColor blackColor];
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _progress.progress=0.7;
        //设置进度条上进度的颜色
        _progress.progressTintColor=[UIColor redColor];
        //设置进度条的背景图片
        _progress.trackImage=[UIImage imageNamed:@"logo.png"];
        //设置进度条上进度的背景图片
        _progress.progressImage=[UIImage imageNamed:@"1.png"];
        //设置进度值并动画显示
        [_progress setProgress:0.7 animated:YES];
    }
    return _progress;
}

#pragma mark - UISlider
/*
 （1）滑动条的左右端背景可以设置上一页下一页的图片；
 
 （2）滑动条的轨道图片可以设置为渐变等等图片。
 
 （3）滑动条因为值可以互动，所以addTarget:方法很重要，其中事件值变动UIControlEventValueChanged比较特殊，其实和按钮的按下事件是一个性质，都是一个事件而已。
 */
- (UISlider *)slider {
    if (!_slider) {
        UISlider *slider = [[UISlider alloc] init];
        
        //设置控件位置和大小，大小不影响控件本身大小，但当高度设置为0，滑块不可拖动
        slider.frame=CGRectMake(30, 80, 200, 50);
        
        //设置值
        slider.value = 0.8;
        slider.minimumValue = 1;
        slider.maximumValue = 10;
        
        //设置已经滑过一端滑动条颜色
        slider.minimumTrackTintColor = [UIColor redColor];
        
        //设置未滑过一端滑动条颜色
        slider.maximumTrackTintColor = [UIColor blackColor];
        
        //设置最小值一端图片，会挤压滑动条宽度
        slider.minimumValueImage = [UIImage imageNamed:@"progress_error"];
        
        //设置最大值一端图片，会挤压滑动条宽度
        slider.minimumValueImage = [UIImage imageNamed:@"progress_success"];
        
        //设置滑块颜色，貌似无效，可能是默认的时图片，已经覆盖了颜色
        slider.thumbTintColor = [UIColor yellowColor];
        
        //设置已经滑过一端滑动条背景图片，会覆盖之前之前的颜色，以下相同
        //[slider setMinimumTrackImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        //设置未滑过一端滑动条背景图片
        //[slider setMaximumTrackImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        //设置滑块图片背景
        //[slider setThumbImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        
        //最重要的就是根据滑动事件来进行相应操作
        //此处和按钮的类似，但是按钮的事件是按下，而这里的事件是UIControlEventValueChanged值变化就是事件
        [slider addTarget:self action:@selector(getValue:) forControlEvents:UIControlEventValueChanged];
        
        _slider = slider;
        
    }
    return _slider;
}

- (void)getValue:(UISlider *)slider{
    NSLog(@"%.2f", slider.value);
}

#pragma mark - UISwitch
/*
 （1）UISwitch的大小也是固定的，不随我们frame设置的大小改变；也是裁剪成圆角的，设置背景就露马脚发现背景是矩形。
 
 （2）UISwitch的背景图片设置无效，即我们只能设置颜色，不能用图片当背景，虽然实验了很小的图片，也是不行。可能需要借助第三方类来实现。
 
 （3）UISwitch也可以增加addTarget:方法，来获取值变动的操作，从而做出响应的反应。
 
 （4）.isOn属性比较特殊，不能设置值，因为是getter方法，不是setter方法，所以只能获取值，例如判断是否开启，一般用在if语句中。
 */
- (UISwitch *)switchV {
    if (!_switchV) {
        UISwitch *switchView = [[UISwitch alloc] init];
        //设置控件位置和大小，大小不影响控件本身大小，
        switchView.frame=CGRectMake(30, 130, 200, 50);
        
        //设置背景，发现上面设置的框的大小确实无效，因为背景只有控件那么大，并不是设置的那么大，而且控件是圆角
        switchView.backgroundColor=[UIColor redColor];
        
        //设置ON一边的背景颜色，默认是绿色
        switchView.onTintColor = [UIColor yellowColor];
        
        //设置OFF一边的背景颜色，默认是灰色，发现OFF背景颜色其实也是控件”边框“颜色
        switchView.tintColor = [UIColor purpleColor];
        
        //设置滑块颜色
        switchView.thumbTintColor = [UIColor greenColor];
        
        //switchView.onImage = [UIImage imageNamed:@"progress_success"];
        //switchView.offImage = [UIImage imageNamed:@"progress_error"];
        
        //开关控件默认是关闭的，setOn可以默认成打开，所以其实它在显示的时候有一个打开的动作，但这个动作不发送消息，即捕捉不到
        //如我们做个试验，弄个针对“值变动”所引发的操作，即值发生变动，开启输出“On”，关闭输出“Off”
        //发现第一次并没有输出On，我们自己手动从关闭到开启时会有On和Off
        //所以这个setOn虽然是一个开启动作，但我们可以认为它相当于是内置了，我们看不到这个动作，所以捕捉不到
        //但这里我们练习了获取值变动病利用isOn来做相应的操作
        [switchView addTarget:self action:@selector(getValue2:) forControlEvents:UIControlEventValueChanged];
        
        //设置成开启病设置动画形式出现，当然也可以直接用[swi1 setOn:YES]; 第一次并没有输出On
        [switchView setOn:YES animated:YES];
        
        _switchV = switchView;
    }
    return _switchV;
}

- (void)getValue2:(UISwitch *)swi2{
    if (swi2.isOn) {
        NSLog(@"On");
    }else{
        NSLog(@"Off");
    }
}

@end
