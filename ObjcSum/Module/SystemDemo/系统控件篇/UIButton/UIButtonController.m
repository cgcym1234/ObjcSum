//
//  UIButtonController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIButtonController.h"

@interface UIButtonController ()

@end

@implementation UIButtonController

#pragma mark 创建按钮
- (void)buttonInit
{
    /**
     （1）UIButton类继承自UIControl，而UIControl继承自UIView，因为UIView就是个矩形区域，所以UIButton实例化的对象其实都是一个矩形，虽然有各种圆角、增加联系人、信息按钮等等，给它们加个背景它们就现形成矩形了，而且它们有个frame属性，这就是设置位置和矩形框的。
     */
    
    /**
     （2）UIButton创建一个按钮不用实例化，也就是不用alloc和init，而是直接调用内置的几个工厂方法即可，这一点和UILabel *label1=[[UILabel alloc]init]不同，而且这些类型里面最常用的时Custom类型，因为我们可以自定义图片，以及图片和文字的位置。
     */
    
    /**
     （3）按钮有很多状态，正常状态Normal、被点击时状态Highlighted等等，所以可以分别对不同状态设置属性。
     
     */
    
    /**
     （4）其实按钮最重要的不是上面那些设置属性，而是按钮关联的操作是什么？即点击后发生什么，这需要一个addtarget操作函数，如果多个按钮用到同一个函数，则需要tag属性来区别是哪个按钮。
     */
    
    /**
     （5）要自定义按钮，一种方式是我们先自定义一个继承UIButton的类，然后对这个类进行重写函数，相当于定制，最后用这个类去创建按钮，这些按钮也就具有自定义的样式（这种方法只针对自定义按钮类型有效）。
     */
    
    
    
    // 1.创建按钮
    // 1.1.创建
    UIButton *btn = [[UIButton alloc] init];
    
    // 1.2.设置按钮的尺寸和位置
    btn.frame = CGRectMake(0, 0, 100, 100);
    
    // 1.3.设置按钮普通状态下的属性
    // 1.3.1.设置背景图片
    UIImage *normal = [UIImage imageNamed:@"btn_01.png"];
    [btn setBackgroundImage:normal forState:UIControlStateNormal];
    // 1.3.2.设置文字
    [btn setTitle:@"点我啊" forState:UIControlStateNormal];
    /*
     // 禁用按钮
     button.enabled = NO;
     // 按钮选中
     button.selected = YES;
     // 设置标题，状态正常
     [button setTitle:@"normal" forState:UIControlStateNormal];
     // 设置标题，状态高亮
     [button setTitle:@"highlighted" forState:UIControlStateHighlighted];
     // 设置标题，状态禁用
     [button setTitle:@"disabled" forState:UIControlStateDisabled];
     // 设置标题，状态选中
     [button setTitle:@"selected" forState:UIControlStateSelected];
     // 设置title的颜色
     [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     */
    

    //生成一个btn1对象，不需要alloc和init，而是直接用内置的工厂方法，有很多可CMD+点击查看
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //设置位置和宽高
    btn1.frame=CGRectMake(30, 30, 300, 30);
    //设置按钮的文字，状态有好几种常用的时Normal和Highlighted（点击时状态），可CMD+点击查看
    [btn1 setTitle:@"点我啊！" forState:UIControlStateNormal];
    //设置点击时的文本
    [btn1 setTitle:@"我被点了！" forState:UIControlStateHighlighted];
    //设置文字颜色
    [btn1 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
#pragma mark - 对齐方式
    //    这里使用
    //    button.titleLabel.textAlignment = NSTextAlignmentLeft; 这行代码是没有效果的，这只是让标签中的文本左对齐，但
    //    并没有改变标签在按钮中的对齐方式。
    //
    //    所以，我们首先要使用
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; //这行代码，把按钮的内容（控件）
    //    的对齐方式修改为水平左对齐，但是这们会紧紧靠着左边，不好看，
    //    所以我们还可以修改属性：
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //这行代码可以让按钮的内容（控件）距离左边10个像素，这样就好看多了
    
    
    
    //设置点击时按钮背景颜色，呃，完全不起作用，即无效果
    [btn1 setTintColor:[UIColor purpleColor]];
    //点击时按钮发光，就是在按钮中间发亮光，这个有效果
    btn1.showsTouchWhenHighlighted=YES;
    //设置tag标签，唯一标记用，可用于分辨是哪个按钮控件
    btn1.tag=1;
    //设置背景颜色
    btn1.backgroundColor=[UIColor redColor];
    //现在高版本的iOS里这个方法会让人抓狂，因为我们发现，不设置背景时，圆角按钮没有边框，所以上面设置frame其实意义不大
    //设置了背景或者图片后，背景是矩形，说好的圆角呢？坑爹呢！
    //所以现在大多数开发都是用UIButtonTypeCustom，而不是UIButtonTypeRoundedRect

    //最重要的添加触发事件用户交互
    //self是指调用哪个对象的方法
    //btnClick:是调用的方法，btnClick和btnClick:不一样，后者表示有参数
    //UIControlEventTouchUpInside是触发事件，有很多，可以CMD+点击查看
    //这里三个参数都可以随意更换，比如新建一个类Hi，在类里定义一个方法-(void)report;
    //然后在此文件引入Hi.h头文件，在这里实例化一个对象hi1，然后就可以用hi1代替self,用report代替btnClick
    //意思就是点击后调用的是hi1对象里面的report方法
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    //再增加一个按钮
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeContactAdd];
    btn2.frame=CGRectMake(30, 80, 300, 30);
    //这个增加联系人按钮其实也是一个矩形，和上面的一样，都是继承自UIControl，而后者又继承自UIView，所以是矩形
    //虽然按钮就一点点大，但点击整个矩形区域都是相当于点击按钮
    btn2.backgroundColor=[UIColor greenColor];
    //设置标签
    btn2.tag=2;
    //增加事件：和btn1调用同一个方法，但问题是我们如果需要区分是哪个按钮的话，就需要用到tag，并且把控件作为参数传递给btnClick
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    //再增加一个最常用的Custom按钮，其他按钮自己尝试
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(30 , 150 , 300, 90);
    btn3.backgroundColor=[UIColor redColor];
    btn3.tag=3;
    
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    /*
     // 用户在控件内按下抬起时
     [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
     // 用户按下时
     [button addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchDown];
     // 用户按下时
     [button addTarget:self action:@selector(outside) forControlEvents:UIControlEventTouchUpOutside];
     // 记录用户多次按下
     [button addTarget:self action:@selector(repeat) forControlEvents:UIControlEventTouchDownRepeat];
     // 用户由内向外
     [button addTarget:self action:@selector(dragExit) forControlEvents:UIControlEventTouchDragExit];
     // 用户由外向内
     [button addTarget:self action:@selector(dragEnter) forControlEvents:UIControlEventTouchDragEnter];
     // 事件的取消
     [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchCancel];
     */
    
    
    
    //设置图片背景被点击时变暗（但没有图片背景时则无效果）
    btn3.adjustsImageWhenHighlighted=YES;
    //所以，增加图片方式之一是增加背景图片，这个图片如小会被放大充满整个背景
    [btn3 setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    //还有一种增加图片的方式，是在按钮上面加而不是背景，这种方式不会缩放图片，而且会居中
    [btn3 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    //设置按钮文字，增加的文字会和setImage图片一并居中，图片在左边，文字紧随其后
    [btn3 setTitle:@"自定义按钮" forState:UIControlStateNormal];
        
    //如果需要重新排版这个图片和按钮文字的位置，则需要重写UIButton类里面的两个函数，点击UIButton可查看
    //- (CGRect)titleRectForContentRect:(CGRect)contentRect;文字相对于按钮的位置
    //- (CGRect)imageRectForContentRect:(CGRect)contentRect;图片相对于按钮的位置
    //第一步：可以重新定义一个UIButton类叫myButton，在.m里重写如下函数
    //- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    //    return CGRectMake(50, 25, 100, 40);
    //}
    //- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    //    return CGRectMake(150, 25, 40, 40);
    //}
    //第二步，在这个文件中引入myButton.h头文件，然后实例化btn3的时候，用myButton，而不用原始的UIButton
    //myButton相当于稍微定制了一下原生的UIButton，所以前者实例出得对象也就具有定制效果
    //这种方式仅对UIButtonTypeCustom有效，其他无效

    //把三个按钮显示出来
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark 监听按钮点击
//增加一个参数，即由原先的-(void)btnClick{}变成如下
//因为我们知道这里都是按钮对象，所以可以用(UIButton *)sender，但通常我们用通用指针id
-(void)btnClick:(id)sender{
    //把传递过来的控件参数转化成按钮
    UIButton *btn=(UIButton *)sender;
    //把btn.tag转化成整型
    NSLog(@"OMG,it is %i",(int)btn.tag);
}


@end
