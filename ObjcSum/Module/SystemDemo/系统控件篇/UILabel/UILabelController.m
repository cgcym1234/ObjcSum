//
//  UILabelController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UILabelController.h"

@interface UILabelController ()

@end

@implementation UILabelController



/**
 *  在iOS中或者Mac OS X中怎样才能将一个字符串绘制到屏幕上呢？
 
 简单来说，是通过控件来完成的，而这些控件都封装在UIKit框架中（对于Mac OS X是AppKit框架），在UIKit中常用来在屏幕上显示字符串的控件有3个：
 
 UILabel
 
 UITextField
 
 UITextView
 
 然而这些控件本身对文本的展现方式很单一，通常仅仅能够控制字体样式、大小、颜色、加粗、斜体等等，而对于行距控制，字距控制，段落控制等高级功能却无能为力。
 
 此时不免要提起一个非常强大的文本排版框架CoreText.framework。
 CoreText框架是基于 iOS 3.2+ 和 OSX 10.5+ 的一种能够对文本格式和文本布局进行精细控制的文本引擎。它良好的结合了 UIKit 和 Core Graphics/Quartz：
 
 
 UIKit 的 UILabel 允许你通过在 IB 中简单的拖曳添加文本，但你不能改变文本的颜色和其中的单词。
 Core Graphics/Quartz几乎允许你做任何系统允许的事情，但你需要为每个字形计算位置，并画在屏幕上。
 
 
 CoreText正结合了这两者！你自己可以完全控制位置、布局、类似文本大小和颜色这样的属性，CoreText将帮你完善其它的东西——类似文本换行、字体呈现等等。
 
 
 然而，CoreText.framework本身非常庞大，学习成本较高，使用起来也不是很方便，所以一般不是特殊需要，很少会有人去使用它。
 
 
 随着iOS6 API的发布，文字显示的API越来越完善，其中一个重要的更新是在UITextField，UITextView和UILabel中加入了对AttributedString的支持，实现行距控制，字距控制，段落控制等高级功能也不必再去使用深奥的CoreText框架。
 
 
 而iOS7的发布，苹果又引入了TextKit,TextKit是一个快速而又现代化的文字排版和渲染引擎。
 
 TextKit并没有新增类，只是在原有的文本显示控件上进行了封装，可以在平时我们最喜欢使用的UILabel，UITextField，UITextView等控件里面使用，其最主要的作用就是为程序提供文字排版和渲染的功能。
 苹果引入TextKit的目的并非要取代已有的CoreText框架，虽然CoreText的主要作用也是用于文字的排版和渲染，但它是一种先进而又处于底层技术，如果我们需要将文本内容直接渲染到图形上下文(Graphics context)时，从性能和易用性来考虑，最佳方案就是使用CoreText。而如果我们需要直接利用苹果提供的一些控件(如UITextView、UILabel和UITextField等)对文字进行排版，那么借助于UIKit中TextKit提供的API无疑更为方便快捷。
 TextKit在文字处理方面具有非常强大的功能，并且开发者可以对TextKit进行定制和扩展。据悉，苹果利用了2年的时间来开发TextKit，相信这对许多开发者来说都是福音。
 
 然而，无论CoreText还是TextKit都不在本文讨论的范畴，因为它们都是非常庞大的体系，而我们的需求通过一个简单小巧的AttributedString就可以轻松搞定，所以本文的关注点只有一个，那就是AttributedString，至于CoreText和TextKit，在真正需要的时候再进行深入研究和总结。

 OK，啰嗦完毕，进入正题。
 
 与NSString类似，在iOS中AttributedString也分为NSAttributedString和NSMutableAttributedString，不同的是，AttributedString对象多了一个Attribute的概念，一个AttributedString的对象包含很多的属性，每一个属性都有其对应的字符区域，在这里是使用NSRange来进行描述的。
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)labelInit
{
    
    //初始化一个label1标签对象，初始化有很多方法，最原始的就是init，此处用带有frame的方法
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(30, 30, 300, 30)];
    //设置内容
    label1.text=@"我是 label 123 hello world 你好吗？在家吗？";
    //设置文字颜色
    label1.textColor=[UIColor whiteColor];
    //设置标签背景，clearColor是透明背景的意思
    label1.backgroundColor=[UIColor redColor];
    //设置文字对齐
    label1.textAlignment=NSTextAlignmentCenter;
    //设置字体，UIFont类有很多设置字体的方法，CMD+点击可查看。
    label1.font=[UIFont boldSystemFontOfSize:23];
    //这个字体设置会覆盖上面的设置，但字是否会倾斜加粗则需要看具体的字体
    label1.font=[UIFont italicSystemFontOfSize:23];
    //打印出所有系统字体，也是用得UIFont里一个方法，可CMD+点击查看
    NSArray *arr1=[UIFont familyNames];
    for (NSString *name in arr1) {
        NSLog(@"%@",name);
    }
    //一般可用，同时修改字体和字号的方法
    label1.font=[UIFont fontWithName:@"Georgia" size:40];
    //设置阴影颜色
    label1.shadowColor=[UIColor blackColor];
    //设置阴影偏移值，需要CGSizeMake值，第一个表示左右偏移，＞0向右；第二个表示上下偏移，>0向下
    label1.shadowOffset=CGSizeMake(2, 5);
    //设置高亮，如果设置为YES，则下面的高亮颜色会替换原先的textColor,而如果设置为No，或者高亮没开启，则高亮颜色设置无效，还是显示textColor值
    label1.highlighted=YES;
    label1.highlightedTextColor=[UIColor redColor];
    //根据标签大小自动调整文字大小，如否不开启，则多余的文字用...表示
    label1.adjustsFontSizeToFitWidth=YES;
    //文字与标签的对齐，依次是文本顶端、中间、底端于标签的中线对齐。可CMD+点击以下任意一个值，发现这是一枚举，默认值是UIBaselineAjustmentAlignBaselines
    //以下方法仅当只有一行文本时有效
    label1.baselineAdjustment=UIBaselineAdjustmentAlignBaselines;
    label1.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    label1.baselineAdjustment=UIBaselineAdjustmentNone;
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30, 80, 300, 80)];
    label2.text=@"hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world ";
    //文字很多时，还是显示1行，最后以...省略
    //设置显示的行数，0是不限制多少行，但由于标签高度一定，如果显示不下，最终仍以...省略
    label2.numberOfLines=0;
    //设置换行和最后截断/省略
    //NSLineBreakByWordWrapping-以单词为单位换行，以单词为单位截断（即没有...，显示不了的直接截断不显示），默认，CMD+点击发现也是一枚举
    //NSLineBreakByCharWrapping-以字符为单位换行，以字符为单位截断
    //NSLineBreakByClipping-以单词为单位换行，以字符为单位截断
    //NSLineBreakByTruncatingHead-以单位为单位换行，以字符为单位截断，但最后一行的前面是...省略，如果是一行，则就在一行的开头有...
    //NSLineBreakByTruncatingTail-以单位为单位换行，以字符为单位截断，但最后一行的末尾是...省略，如果是一行，则就在一行的末尾有...
    //NSLineBreakByTruncatingMiddle-以单位为单位换行，以字符为单位截断，但最后一行的中间是...省略，如果是一行，则就在一行的中间有...
    label2.lineBreakMode=NSLineBreakByTruncatingHead;
    
    //根据内容调整标签大小，三部曲
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectZero];
    label3.text=@"标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3 标签3";
    //1、计算内容大小，即获得高和宽，其实宽一般都给定了，只是计算高，而高宽二位对象一般是一个CGSize
    CGSize size1=[label3.text sizeWithFont:label3.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    //2、设置显示行数，即不限制函数
    label3.numberOfLines=0;
    //3、利用size1设置标签的宽和高
    label3.frame=CGRectMake(30, 180, size1.width, size1.height);
    //把上面初始化的标签label1、2、3增加到当前的view里，一并显示出来
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

/**
 *  使用AttributedString的方式通常有两种：
 方式一：
 首先初始化一个NSMutableAttributedString，然后向里面添加文字样式，最后将它赋给控件的AttributedText，该方法适合于文本较少而又需要分段精细控制的情况。
 
 */

- (void)AttributedStringTest1
{
    NSString *str = @"hello,中秋节";
    
    //创建 NSMutableAttributedString
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Zapfino" size:15],
                           NSForegroundColorAttributeName: [UIColor blueColor]};
    
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Zapfino" size:15] range:NSMakeRange(0, str.length)];
    
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attribute1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 6)];
    
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Zapfino" size:15] range:NSMakeRange(6, str.length-6)];
}

/**
 *  方式二：
 
 首先创建属性字典，初始化各种属性，然后和需要控制的文本一起创建并赋值给控件的AttributedText，该方法适合于需要控制的文本较多整体控制的情况，通常是从文件中读取的大段文本控制。
 //方式二
 
 //创建属性字典
 NSDictionary *attrDict = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],
 NSForegroundColorAttributeName: [UIColor blueColor] };
 
 //创建 NSAttributedString 并赋值
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict];
 运行结果：
 
 
 
 通过对比两个例子可以看出，方式一比较容易处理复杂的格式，但是属性设置比较繁多复杂，而方式二的属性设置比较简单明了，却不善于处理复杂多样的格式控制，
 */

/**
 *  好了，讲完AttributedString的创建方式，下面研究下AttributedString究竟可以设置哪些属性，具体来说，有以下21个：
 // NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 // NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 // NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 // NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 // NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 // NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 // NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 // NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 // NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 // NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 // NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 // NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 // NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 // NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 // NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 // NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 // NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 // NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 // NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 // NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 // NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 */
























@end
