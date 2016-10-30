//
//  UIImageController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/5/28.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "UIImageController.h"

@interface UIImageController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation UIImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - Init
- (void)configUI {
    //UIImage实例化一个image对象，并初始化一个图片给它，这步骤相当于把图片移动到应用程序里面
    UIImage *image = [UIImage imageNamed:@"mine"];
    
    //然后UIImageView相当于一个载体，用来显示这个图片对象
    //图片自己不能在程序中显示，需要一个载体，如之前讲UIButton时，图片就是借助按钮这个载体显示的
    //所以UIImage的对象img1没有frame框架
    //只有UIImageView的对象imgView1才有frame属性，它装着图片，然后我们对它位置大小进行设置即可
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    //意料之中：图片被自动缩放了，缩放到frame的大小
    imageView.frame=CGRectMake(30, 30, 300, 80);
    
    
    //那如果需要原图小小呢？
    //(1)如果知道原图宽高，直接把数字写进去
    //(2)调用图片size里地宽高属性，如imgView1.frame=CGRectMake(30, 30, img1.size.width, img1.size.height)
    
    //随之而来的时，如果我既想保持imgView1的宽高不变，又想图片不被缩放
    //需要用到内容模式属性
    //先弄个背景来做效果演示用
    imageView.backgroundColor = [UIColor redColor];
    
    //尝试其中一个，发现居中了，而且图片没有被缩放了
    //这个contentMode内容模式是UIView的方法，不仅仅是UIImage（继承自UIView）的方法，所以我们看它的类型前面有UIView，如UIViewContentModeCenter
    //    [imgView1 setContentMode:UIViewContentModeCenter];
    //其他类型都是固定位置的，如上下左右左下右上等，下面几个是重点和常用的
    //UIViewContentModeScaleToFill是填满，当然图片会被不等比例的缩放，和没有内容模式属性前一样
    //UIViewContentModeScaleAspectFill是等比例缩放的填满，可以想象有一边长度正好，还有一边有可能超出了整个imgView1的frame边界
    //UIViewContentModeScaleAspectFit是等比例缩放的填充到最大尺寸，可以想见有一边长度正好，还有一边有可能还没达到frame的边界
    [imageView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:imageView];
    
    #pragma mark - //设置动画
    //先弄一个UIImageView准备加载，本来是UIImageView *imgView2=[[UIImageView alloc]init]但imgView2已在顶部声明为全局变量，此处只需初始化即可
    UIImageView *imgView2=[[UIImageView alloc]init];
    imgView2.frame=CGRectMake(30, 150, 40, 40);
    //把需要动画的一系列图片导入到一个数组中，少的话就不需要用for循环导入
    NSMutableArray *arr1=[[NSMutableArray alloc]init];
    for (int i=1; i<=3; i++) {
        UIImage *img2=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",i]];
        [arr1 addObject:img2];
    }
    //1、先把这个数组装到动画图片中
    imgView2.animationImages=arr1;
    //2、设置播放时间，即每次全部完全播放完的时间
    imgView2.animationDuration=1;
    //3、设置重复播放次数，如不设置或为0时，表示无限循环
    imgView2.animationRepeatCount=0;
    //4、还要启动，才能播放
    [imgView2 startAnimating];
    //当然还要加载进来才能显示
    [self.view addSubview:imgView2];
}




























@end
