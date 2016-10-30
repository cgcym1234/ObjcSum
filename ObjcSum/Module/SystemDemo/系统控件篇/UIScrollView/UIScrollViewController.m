//
//  UIScrollViewController.m
//  View控件的总结
//
//  Created by yang on 7/31/14.
//  Copyright (c) 2014 yang. All rights reserved.
//

#import "UIScrollViewController.h"

@interface UIScrollViewController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation UIScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - Init
- (void)configUI {
    //    返回整个屏幕的边界，包括状态栏所显示的空间
    //CGRect *screenBounds = [[UIScreen mainScreen] bounds];
        
    //返回屏幕的可显示区域
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    //frame = (0 20; 375 647);
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    
    scrollView.delegate = self;
    //    scrollView.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0.jpg"]];
    
    #pragma mark - 
    //imageView 的大小会随着缩放时候改变
    //比如：frame = (38.0401 67.6607; 285.852 508.436);
    imageView.frame = self.view.frame;
    [scrollView addSubview:imageView];
    _imageView = imageView;
    
    //imageView.center  = scrollView.center;
    
    //设置内容的尺寸大小
    scrollView.contentSize = imageView.frame.size;
    
    //设置是否显示滑动条
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    
    //pagingEnabled属性，页面翻转
    scrollView.pagingEnabled = NO;
    
    //缩放的最大最小值
    scrollView.minimumZoomScale = 0.25;
    scrollView.maximumZoomScale = 2.5;
    
    //indicatorStyle指定滚动指示条类型
    //滚动指示器类型，默认白边界上绘制黑色滚动条 3种
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    
    //directionalLockEnabled属性，设置为YES将滚动锁定在一个方向上进行。
    scrollView.directionalLockEnabled = NO;
    
    //bounces属性，弹簧效果，YES时滚动到边缘可超为超出界面外一点然后弹回原位
    //NO时滚动不会超出可见范围
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;
    
    //bouncesZoom属性，类似bounds 指的用户的缩放
    //NO时缩放不可超出最大最小缩放范围
    //    scrollView.bouncesZoom = NO;
    
    //pagingEnabled属性，页面翻转
    scrollView.pagingEnabled = NO;
    
    //    scrollView.contentOffset = YES;
    
}




#pragma mark -- UIScrollView 代理方法

#pragma mark 响应缩放方法
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _imageView.center = scrollView.center;
}


#pragma mark 在视图滚动时接到通知，包括一个指向被滚动视图的指针，从中可读取contentOffset属性已确定其滚动到的位置,常用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark 拖动之前收到通知，可读取contentOffset
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

#pragma mark 用户抬起手指时得到通知，还会得到一个布尔值指明在报告滚动视图最后位置之前，手否需要进行减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

#pragma mark 当用户抬起手指为滚动视图需要继续滚动时收到通知，可读取contentOffset属性，可判断用户抬起手指前最后一次滚动到的位置，但不是最终位置
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark 当前一个提到的减速完毕、滚动视图停止移动时会得到通知，收到这个通知的时刻，滚动视图contentOffset属性会反映出滚动条最终停止位置
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark 用户进行缩放时会得到通知，缩放比例表示为一个浮点数，作为参数传递
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

#pragma mark 当用户点触iPhone的状态条时滚动视图代理可以决定视图是否应滚定回到开头
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return  YES;
}

#pragma mark 当用户点触iPhone的状态条时滚动视图代理可以决定视图是否应滚定回到开头
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}

@end
