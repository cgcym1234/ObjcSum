//
//  UITextFieldController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UITextFieldController.h"
//#import "YYInputAccessoryView.h"

@interface UITextFieldController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textFiexd;
@end

@implementation UITextFieldController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textFiexd];
}

#pragma mark 创建UITextField

/*
 （1）可以根据需要设置文本框的样式（包括形状、边框颜色、背景等）。
 
 （2）可以根据需要设置文字显示样式（包括输入密码时的密文显示、文字横向居中、纵向居中上下、输入的文字是否首席木大写、文字超过后是否缩小还是向右滚动等）。
 
 （3）可以根据需要设置各种不同的键盘样式（只有数字、只有字母等等）。
 
 （4）还有inputView可以弹出一个视图，用于取代弹出键盘，暂时不知道什么用处，但貌似可以用得地方很多啊。
 
 （5）还有return的样式设置，可以设置为Google也可以设置为Go和Search等更形象的按钮。
 
 （6）还有一个clearsOnBeginEditing是否设置清除按钮也很常用。
 
 （7）还有用得比较多得估计是左右视图，也就是我们常见的用户名和密码的前面还有一个小icon图片表示用户的“小人”和表示密码的“锁”的图片，用左右视图可以加载进来，当然最后要记得设置左右视图模式为Always，不然默认是Never不显示的。
 */
- (UITextField *)textFiexd {
    if (!_textFiexd) {
        CGRect frame = CGRectMake(50, 200, 200, 44);
        UITextField *text = [[UITextField alloc] initWithFrame:frame];
        //此时text已存在，但因为是透明背景，所以看不见，但是点击那块地方会发现光标闪烁可写
        //为了证明是透明背景而不是白色背景，我们可以设置self.view背景为红色，看看textField1是白色还是透明色
        //    self.view.backgroundColor=[UIColor redColor];
        
        //设置边框样式，只有设置了才会显示边框样式
        text.borderStyle = UITextBorderStyleRoundedRect;
        //UITextBorderStyleRoundedRect-圆角矩形，背景是白色，不再是透明的
        //UITextBorderStyleLine-矩形，黑色边框，透明背景
        //UITextBorderStyleBezel-和上面类似，但是是灰色的边框，背景透明
        
        
        //设置输入框的背景颜色，会覆盖上面圆角矩形默认的白色背景, 如果使用了自定义的背景图片边框会被忽略掉
        text.backgroundColor = [UIColor purpleColor];
        
        //设置背景 注意只有UITextBorderStyleNone的时候改属性有效
        text.background = [UIImage imageNamed:@"dd.png"];
        
        //设置背景
        text.disabledBackground = [UIImage imageNamed:@"cc.png"];
        //当输入框没有内容时，水印提示 提示内容为password
        text.placeholder = @"password";
        
        //设置输入框内容的字体样式和大小
        text.font = [UIFont fontWithName:@"Arial" size:20.0f];
        
        //设置字体颜色
        text.textColor = [UIColor redColor];
        
        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        //    typedef enum {
        //        UItextViewModeNever,　重不出现
        //        UItextViewModeWhileEditing, 编辑时出现
        //        UItextViewModeUnlessEditing,　除了编辑外都出现
        //        UItextViewModeAlways 　一直出现
        //    } UItextViewMode;
        
        //输入框中一开始就有的文字
        text.text = @"一开始就在输入框的文字";
        
        //每输入一个字符就变成点 用语密码输入
        text.secureTextEntry = YES;
        
        //是否纠错
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        //    typedef enum {
        //        UITextAutocorrectionTypeDefault, 默认
        //        UITextAutocorrectionTypeNo, 　不自动纠错
        //        UITextAutocorrectionTypeYes,　自动纠错
        //    } UITextAutocorrectionType;
        
        //再次编辑就清空
        text.clearsOnBeginEditing = YES;
        
        //内容对齐方式
        text.textAlignment = NSTextAlignmentLeft;
        /*
         typedef NS_ENUM(NSInteger, NSTextAlignment) {
         NSTextAlignmentLeft      = 0,    // Visually left aligned
         #if TARGET_OS_IPHONE
         NSTextAlignmentCenter    = 1,    // Visually centered
         NSTextAlignmentRight     = 2,    // Visually right aligned
         #else  !TARGET_OS_IPHONE
         NSTextAlignmentRight     = 1,    // Visually right aligned
         NSTextAlignmentCenter    = 2,    // Visually centered
         #endif
         NSTextAlignmentJustified = 3,    // Fully-justified. The last line in a paragraph is natural-aligned.
         NSTextAlignmentNatural   = 4,    // Indicates the default alignment for script
         } NS_ENUM_AVAILABLE_IOS(6_0);
         
         */
        
        //内容的垂直对齐方式  UItext继承自UIControl,此类中有一个属性contentVerticalAlignment
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
        text.adjustsFontSizeToFitWidth = YES;
        
        //设置自动缩小显示的最小字体大小
        text.minimumFontSize = 20;
        
        //设置键盘的样式
        text.keyboardType = UIKeyboardTypeNumberPad;
        //    typedef enum {
        //        UIKeyboardTypeDefault,     　默认键盘，支持所有字符
        //        UIKeyboardTypeASCIICapable,　支持ASCII的默认键盘
        //        UIKeyboardTypeNumbersAndPunctuation,　标准电话键盘，支持＋＊＃字符
        //        UIKeyboardTypeURL,            URL键盘，支持.com按钮 只支持URL字符
        //        UIKeyboardTypeNumberPad,            　数字键盘
        //        UIKeyboardTypePhonePad,　 　  电话键盘
        //        UIKeyboardTypeNamePhonePad, 　电话键盘，也支持输入人名
        //        UIKeyboardTypeEmailAddress, 　用于输入电子 邮件地址的键盘
        //        UIKeyboardTypeDecimalPad,   　数字键盘 有数字和小数点
        //        UIKeyboardTypeTwitter,      　优化的键盘，方便输入@、#字符
        //        UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,
        //    } UIKeyboardType;
        //注意：如果是最xcode6下的模拟器的话，默认是不调出软键盘的，按CMD+K可以调出，或者在菜单Hardware里地Keyboard里设置
        
       #pragma mark -  //首字母是否大写
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //    typedef enum {
        //        UITextAutocapitalizationTypeNone, 不自动大写
        //        UITextAutocapitalizationTypeWords,　单词首字母大写
        //        UITextAutocapitalizationTypeSentences,　句子的首字母大写
        //        UITextAutocapitalizationTypeAllCharacters, 所有字母都大写
        //    } UITextAutocapitalizationType;
        
        //return键变成什么键
        text.returnKeyType =UIReturnKeyDone;
        //    typedef enum {
        //        UIReturnKeyDefault, 默认 灰色按钮，标有Return
        //        UIReturnKeyGo,    　标有Go的蓝色按钮
        //        UIReturnKeyGoogle,标有Google的蓝色按钮，用语搜索
        //        UIReturnKeyJoin,标有Join的蓝色按钮
        //        UIReturnKeyNext,标有Next的蓝色按钮
        //        UIReturnKeyRoute,标有Route的蓝色按钮
        //        UIReturnKeySearch,标有Search的蓝色按钮
        //        UIReturnKeySend,标有Send的蓝色按钮
        //        UIReturnKeyYahoo,标有Yahoo的蓝色按钮
        //        UIReturnKeyYahoo,标有Yahoo的蓝色按钮
        //        UIReturnKeyEmergencyCall, 紧急呼叫按钮
        //    } UIReturnKeyType;
        
        
        //设置键盘外观
        text.keyboardAppearance=UIKeyboardAppearanceDefault;
        //    typedef enum {
        //        UIKeyboardAppearanceDefault， 默认外观，浅灰色
        //        UIKeyboardAppearanceAlert，　 　深灰 石墨色
        //    } UIReturnKeyType;
        //UIKeyboardAppearanceDark和UIKeyboardAppearanceAlert都是把键盘背景变成半透明灰色区别不明显
        //UIKeyboardAppearanceLight貌似和UIKeyboardAppearanceDefault一样，没啥区别
        
        
        
        //最右侧加图片是以下代码　 左侧类似
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_username.png"]];
        //    text.rightView=image;
        //    text.rightViewMode = UITextFieldViewModeAlways;
        text.leftView = image;
        text.leftViewMode =UITextFieldViewModeAlways;
        
        
        #pragma mark - 将出现的键盘改成自定义view
        /**
         *  将出现的键盘改成自定义view
         比如改成了时间选择器
         */
        UIPickerView *picker = [[UIPickerView alloc] init];
        //text.inputView = picker;
        
//        YYInputAccessoryView *topView = [[YYInputAccessoryView alloc] init];
        __weak typeof(self) weakSelf = self;
//        topView.rightBtnClickedBlock = ^(YYInputAccessoryView *view) {
//            [weakSelf.view endEditing:YES];
//        };
        
        //键盘上面加一层辅助ToolBar，
//        text.inputAccessoryView = topView;
        
        //设置代理 用于实现协议
        text.delegate = self;
        [self.view addSubview:text];
        
        /**
         *  界面重写绘制行为
         除了UItext对象的风格选项，你还可以定制化UItext对象，为他添加许多不同的重写方法，来改变文本字段的显示行为。
         这些方法都会返回一个CGRect结构，制定了文本字段每个部件的边界范围。以下方法都可以重写。
         
         – textRectForBounds:　　  　//重写来重置文字区域
         – drawTextInRect:　　      　//改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
         – placeholderRectForBounds:　　//重写来重置占位符区域
         – drawPlaceholderInRect:　　//重写改变绘制占位符属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
         – borderRectForBounds:　　//重写来重置边缘区域
         – editingRectForBounds:　　//重写来重置编辑区域
         – clearButtonRectForBounds:　　//重写来重置clearButton位置,改变size可能导致button的图片失真
         – leftViewRectForBounds:
         – rightViewRectForBounds:
         
         代替输入
         inputView //代替标准的系统键盘
         inputAccessoryView //编辑时显示在系统键盘或用户自定义的inputView上面的视图
         */
        
        /*
         通知
         UITextField派生自UIControl，所以UIControl类中的通知系统在文本字段中也可以使用。除了UIControl类的标准事件，你还可以使用下列UItext类特有的事件
         
         UITextFieldFieldTextDidBeginEditingNotification
         UITextFieldTextDidChangeNotification
         UITextFieldTextDidEndEditingNotification
         当文本字段退出编辑模式时触发。通知的object属性存储了最终文本。
         
         因为文本字段要使用键盘输入文字，所以下面这些事件发生时，也会发送动作通知
         
         UIKeyboardWillShowNotification 　//键盘显示之前发送
         UIKeyboardDidShowNotification  　//键盘显示之后发送
         UIKeyboardWillHideNotification 　//键盘隐藏之前发送
         UIKeyboardDidHideNotification  　//键盘隐藏之后发送
         
         
         NIB中：
         1、Text ：设置文本框的默认文本。
         2、Placeholder ： 可以在文本框中显示灰色的字，用于提示用户应该在这个文本框输入什么内容。当这个文本框中输入了数据时，用于提示的灰色的字将会自动消失。
         3、Background ：
         4、Disabled ： 若选中此项，用户将不能更改文本框内容。
         5、接下来是三个按钮，用来设置对齐方式。
         6、Border Style ： 选择边界风格。
         7、Clear Button ： 这是一个下拉菜单，你可以选择清除按钮什么时候出现，所谓清除按钮就是出一个现在文本框右边的小 X ，你可以有以下选择：
         7.1 Never appears ： 从不出现
         7.2 Appears while editing ： 编辑时出现
         7.3 Appears unless editing ：
         7.4 Is always visible ： 总是可见
         8、Clear when editing begins ： 若选中此项，则当开始编辑这个文本框时，文本框中之前的内容会被清除掉。比如，你现在这个文本框 A 中输入了 "What" ，之后去编辑文本框 B，若再回来编辑文本框 A ，则其中的 "What" 会被立即清除。
         9、Text Color ： 设置文本框中文本的颜色。
         10、Font ： 设置文本的字体与字号。
         11、Min Font Size ： 设置文本框可以显示的最小字体（不过我感觉没什么用）
         12、Adjust To Fit ： 指定当文本框尺寸减小时，文本框中的文本是否也要缩小。选择它，可以使得全部文本都可见，即使文本很长。但是这个选项要跟 Min Font Size 配合使用，文本再缩小，也不会小于设定的 Min Font Size 。
         接下来的部分用于设置键盘如何显示。
         13、Captitalization ： 设置大写。下拉菜单中有四个选项：
         13.1 None ： 不设置大写
         13.2 Words ： 每个单词首字母大写，这里的单词指的是以空格分开的字符串
         13.3 Sentances ： 每个句子的第一个字母大写，这里的句子是以句号加空格分开的字符串
         13.4 All Characters ： 所以字母大写
         14、Correction ： 检查拼写，默认是 YES 。
         15、Keyboard ： 选择键盘类型，比如全数字、字母和数字等。
         16、Appearance：
         17、Return Key ： 选择返回键，可以选择 Search 、 Return 、 Done 等。
         18、Auto-enable Return Key ： 如选择此项，则只有至少在文本框输入一个字符后键盘的返回键才有效。
         19、Secure ： 当你的文本框用作密码输入框时，可以选择这个选项，此时，字符显示为星号。
         
         
         1.Alignment Horizontal 水平对齐方式
         2.Alignment Vertical 垂直对齐方式
         3.用于返回一个BOOL值　输入框是否 Selected(选中) Enabled(可用) Highlighted(高亮)
         
         */
        _textFiexd = text;
    }
    return _textFiexd;
    
}


#pragma mark -- UITextField 委托方法

//设置文本框是否可以编辑，NO的话就不可编辑，默认是YES
- (BOOL)textShouldBeginEditing:(UITextField *)text{
    return YES;
}

//开始编辑时触发，文本字段将成为first responder
- (void)textDidBeginEditing:(UITextField *)text{
    NSLog(@"已经编辑中");
}

//是否可以结束编辑，如果是NO的话，那么你指向其他地方，这个光标还在这里跳动编辑，默认是YES
- (BOOL)textShouldEndEditing:(UITextField *)text{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    
    return NO;
}

// 上面返回YES后执行;上面返回NO时有可能强制执行(e.g. view removed from window)
- (void)textDidEndEditing:(UITextField *)text;{
    NSLog(@"编辑结束了");
}

- (BOOL)textField:(UITextField*)text shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
    //输入为换行时，退出键盘
    if ([string isEqualToString:@"\n"]) {
        [text resignFirstResponder];
        return NO;
    }
    
    
    //限制输入字数
    if (text.text.length > 200) {
        //[Util showTip:@"您最多只能输入200个字哦"];
        return NO;
    }
    
    return YES;

}


//是否可清除。如果是NO的话，我们结束编辑时虽然有叉叉X，但是点击无法清除
//但我们可以手动清除，即虽然设置为NO，但同时设置它的文本为空，如下
//区别在于，后者，我们编辑其他文本框时点击它清除，这个时候光标还是原来文本框中，不会跳到这个清除的文本框里
- (BOOL)textShouldClear:(UITextField *)text{
    
    return YES;
}

//是否可点击return键，NO设置貌似暂时无法看到效果。
//我们用得比较多得功能是按return后隐藏键盘
-(BOOL)textShouldReturn:(UITextField *)text{
    [text resignFirstResponder];
    return YES;
}

@end
