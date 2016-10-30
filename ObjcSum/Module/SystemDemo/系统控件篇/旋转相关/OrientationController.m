//
//  OrientationController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/2.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "OrientationController.h"

@interface OrientationController ()

@end

@implementation OrientationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 一、两种orientation
/*
 了解屏幕旋转首先需要区分两种orientation
 
 1、device orientation
 设备的物理方向
 
 2、interface orientation
 界面显示的方向
 
 3. landscape 表示横向    portrait 表示纵向
 */
- (void)orientationDemo {
    //1. UIDeviceOrientation 设备的物理方向，只能读，不能修改
    typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
        UIDeviceOrientationUnknown,
        UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
        UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
        UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
        UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
        UIDeviceOrientationFaceUp,              // Device oriented flat, face up
        UIDeviceOrientationFaceDown             // Device oriented flat, face down
    };
    
    //2. UIInterfaceOrientation程序界面的方向，可以修改
    typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
        UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
        UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
        UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
        UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
    };
    
    #pragma mark -  获取设备方向发生的变化，需要注册UIDeviceOrientationDidChangeNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
}

#pragma mark - UIKit处理屏幕旋转的流程
/*
 　　当加速计检测到方向变化的时候，会发出 UIDeviceOrientationDidChangeNotification 通知，这样任何关心方向变化的view都可以通过注册该通知，在设备方向变化的时候做出相应的响应。上一篇博客中，我们已经提到了在屏幕旋转的时候，UIKit帮助我们做了很多事情，方便我们完成屏幕旋转。
 
 　　UIKit的相应屏幕旋转的流程如下：
 
 1、设备旋转的时候，UIKit接收到旋转事件。
 
 2、UIKit通过AppDelegate通知当前程序的window。
 
 3、Window会知会它的rootViewController，判断该view controller所支持的旋转方向，完成旋转。
 
 4、如果存在弹出的view controller的话，系统则会根据弹出的view controller，来判断是否要进行旋转。
 */


#pragma mark -  UIViewController实现屏幕旋转
/*
 　　在响应设备旋转时，我们可以通过UIViewController的方法实现更细粒度的控制，当view controller接收到window传来的方向变化的时候，流程如下：
 
 1、首先判断当前viewController是否支持旋转到目标方向，如果支持的话进入流程2，否则此次旋转流程直接结束。
 
 2、调用 willRotateToInterfaceOrientation:duration: 方法，通知view controller将要旋转到目标方向。如果该viewController是一个container view controller的话，它会继续调用其content view controller的该方法。这个时候我们也可以暂时将一些view隐藏掉，等旋转结束以后在现实出来。
 
 3、window调整显示的view controller的bounds，由于view controller的bounds发生变化，将会触发 viewWillLayoutSubviews 方法。这个时候self.interfaceOrientation和statusBarOrientation方向还是原来的方向。
 
 4、接着当前view controller的 willAnimateRotationToInterfaceOrientation:duration: 方法将会被调用。系统将会把该方法中执行的所有属性变化放到动animation block中。
 
 5、执行方向旋转的动画。
 
 6、最后调用 didRotateFromInterfaceOrientation: 方法，通知view controller旋转动画执行完毕。这个时候我们可以将第二部隐藏的view再显示出来。
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (BOOL)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"handleDeviceOrientationDidChange:");
    
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationUnknown: {
            NSLog(@"无法识别");
            break;
        }
        case UIDeviceOrientationPortrait: {
            NSLog(@"UIDeviceOrientationPortrait");
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            NSLog(@"UIDeviceOrientationLandscapeLeft");
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            NSLog(@"UIDeviceOrientationLandscapeRight");
            break;
        }
        case UIDeviceOrientationFaceUp: {
            NSLog(@"UIDeviceOrientationFaceUp");
            break;
        }
        case UIDeviceOrientationFaceDown: {
            NSLog(@"UIDeviceOrientationFaceDown");
            break;
        }
        default: {
            break;
        }
    }
    return YES;
}

#pragma mark - 四、如何决定interface orientation
/*
 1、全局控制
 Info.plist文件中，有一个Supported interface orientations，可以配置整个应用的屏幕方向，此处为全局控制。
 
 
 2、UIWindow
 iOS6的UIApplicationDelegate提供了下述方法，能够指定 UIWindow 中的界面的屏幕方向：
 - (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window  NS_AVAILABLE_IOS(6_0);
 该方法默认值为 Info.plist 中配置的 Supported interface orientations 项的值。
 
 iOS中通常只有一个 window，所以此处的控制也可以视为全局控制。
 
 
 
 3、controller
 只有以下两种情况：
 当前controller是window的rootViewController
 当前controller是modal模式的时，orientations相关方法才会起作用（才会被调用），当前controller及其所有的childViewController都在此作用范围内。
 
 
 4、最终支持的屏幕方向
 前面所述的3种控制规则的交集就是一个controller的最终支持的方向；
 
 如果最终的交集为空，在iOS6以后会抛出UIApplicationInvalidInterfaceOrientationException崩溃异常。
 */

#pragma mark - 五、强制屏幕旋转
/*
 如果interface和device方向不一样，想强制将interface旋转成device的方向，可以通过attemptRotationToDeviceOrientation实现，但是如果想将interface强制旋转成任一指定方向，该方式就无能为力了。
 
 不过聪明的开发者们总能想到解决方式：
 
 1、私有方法
 [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
 
 但是现在苹果已经将该方法私有化了，越狱开发的同学可以试试。
 
 
 
 2、旋转view的transform
 也可以通过旋转view的transform属性达到强制旋转屏幕方向的目的，但个人感觉这不是靠谱的思路，可能会带来某些诡异的问题。
 
 
 
 3、主动触发 orientation 机制
 要是能主动触发系统的 orientation 机制，调用 orientation 相关方法，使新设置的 orientation 值起作用就好了。这样只要提前设置好想要支持的 orientation，然后主动触发 orientation 机制，便能实现将 interface orientation旋转至任意方向的目的。
 
 万能的stackoverflow上提供了一种主动触发的方式：
 
 在iOS 4和iOS 6以后：
 UIViewController *vc = [[UIViewController alloc]init];
 [self presentModalViewController:vc animated:NO];
 [self dismissModalViewControllerAnimated:NO];
 [vc release];
 
 iOS 5中：
 UIWindow *window = [[UIApplication sharedApplication] keyWindow];
 UIView *view = [window.subviews objectAtIndex:0];
 [view removeFromSuperview];
 [window addSubview:view];
 
 这种方式会触发UIKit重新调用controller的orientation相关方法，以达到在device方向不变的情况下改变interface方向的目的。
 
 PS：
 话说iOS8中的屏幕旋转相关方法又变化了，表示适配起来很蛋疼。
 
 */



#pragma mark - 旋转相关API,iOS 6和之后版本
/*
 只有以下两种情况起作用：
 当前controller是window的rootViewController
 当前controller是modal模式的时，orientations相关方法才会起作用（才会被调用），当前controller及其所有的childViewController都在此作用范围内。
 */

//决定是否支持多方向旋转屏，如果返回NO则后面的两个方法都不会再被调用，而且只会支持默认的UIInterfaceOrientationMaskPortrait方向；
- (BOOL)shouldAutorotate{
    return YES;
}

//返回支持的旋转方向，该方法在iPad上的默认返回值是UIInterfaceOrientationMaskAll，iPhone上的默认返回值是UIInterfaceOrientationMaskAllButUpsideDown
-(NSUInteger)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskAllButUpsideDown;
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft);
}

//返回最优先显示的屏幕方向，比如同时支持Portrait和Landscape方向，但想优先显示Landscape方向，那软件启动的时候就会先显示Landscape，在手机切换旋转方向的时候仍然可以在Portrait和Landscape之间切换
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

/*
 该方法的使用场景是 interface orientation和device orientation 不一致，但希望通过重新指定 interface orientation 的值，立即实现二者一致；
 
 如果这时只是更改了支持的 interface orientation 的值，没有调用attemptRotationToDeviceOrientation，那么下次 device orientation 变化的时候才会实现二者一致，关键点在于能不能立即实现。
 
 
 举个例子：
 假设当前的 interface orientation 只支持 Portrait，如果 device orientation 变成 Landscape，那么 interface orientation 仍然显示 Portrait；
 
 如果这时我们希望 interface orientation 也变成和 device orientation 一致的 Landscape，以iOS 6 为例，需要先将 supportedInterfaceOrientations 的返回值改成Landscape，然后调用 attemptRotationToDeviceOrientation方法，系统会重新询问支持的 interface orientation，已达到立即更改当前 interface orientation 的目的。
 */


#pragma mark - 通知view controller将要旋转到目标方向。如果该viewController是一个container view controller的话，它会继续调用其content view controller的该方法。
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //这个时候self.interfaceOrientation和statusBarOrientation方向还是原来的方向。
    
    //这个时候我们也可以暂时将一些view隐藏掉，等旋转结束以后在现实出来。
}

#pragma mark - 紧接着方法将会被调用。系统将会把该方法中执行的所有属性变化放到动animation block中。
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //这个时候self.interfaceOrientation和statusBarOrientation已经是旋转后的方向。
    //self.view也是
}

#pragma mark - 最后调用 didRotateFromInterfaceOrientation: 方法，通知view controller旋转动画执行完毕。
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //这个时候我们可以将第二部隐藏的view再显示出来。
}

+ (void)attemptRotationToDeviceOrientation {
    
}

#pragma mark -  三、注意事项和建议
/*
 
 　　1）注意事项
 
 　　当我们的view controller隐藏的时候，设备方向也可能发生变化。例如view Controller A弹出一个全屏的view controller B的时候，由于A完全不可见，所以就接收不到屏幕旋转消息。这个时候如果屏幕方向发生变化，再dismiss B的时候，A的方向就会不正确。我们可以通过在view controller A的viewWillAppear中更新方向来修正这个问题。
 
 　　2）屏幕旋转时的一些建议
 
 在旋转过程中，暂时界面操作的响应。
 旋转前后，尽量当前显示的位置不变。
 对于view层级比较复杂的时候，为了提高效率在旋转开始前使用截图替换当前的view层级，旋转结束后再将原view层级替换回来。
 在旋转后最好强制reload tableview，保证在方向变化以后，新的row能够充满全屏。例如对于有些照片展示界面，竖屏只显示一列，但是横屏的时候显示列表界面，这个时候一个界面就会显示更多的元素，此时reload内容就是很有必要的。
 */

@end
