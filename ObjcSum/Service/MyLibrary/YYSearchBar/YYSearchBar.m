//
//  YYSearchBar.m
//  ObjcSum
//
//  Created by sihuan on 15/11/13.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYSearchBar.h"

@implementation YYSearchBar

- (void)awakeFromNib {
    [self setContext];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setContext];
    }
    return self;
}

#pragma mark - Private

- (void)setContext {
//    self.tintColor = [UIColor clearColor];
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = ColorFromRGBHex(0xe8e8e8);
    
    [self setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //去掉边框线
//    self.backgroundImage = [self createImageWithColor:[UIColor clearColor]];
    
    for (UIView *subView in self.subviews) {
//        NSLog(@"%@", subView);
        for (UIView *subSubView in subView.subviews) {
//            NSLog(@"%@", subSubView);
            if ([subSubView isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
                subSubView.tintColor = [UIColor clearColor];
            }
            
            if ([subSubView isKindOfClass:NSClassFromString(@"UITextField")]) {
                UITextField *textField = (UITextField *)subSubView;
                //修改placeholder颜色和字体
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: ColorFromRGBHex(0xaaaaaa)}];
            }
        }
    }
    
    
    /**
     *  2015-11-16 10:02:10.502 MLLSalesAssistant[1298:479083] <UIView: 0x15eda3870; frame = (0 0; 600 44); layer = <CALayer: 0x170434660>>
     2015-11-16 10:02:10.503 MLLSalesAssistant[1298:479083] <_UISearchBarScopeBarBackground: 0x15eda3980; frame = (0 0; 600 44); alpha = 0.96; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x1704346a0>>
     2015-11-16 10:02:10.504 MLLSalesAssistant[1298:479083] <UISegmentedControl: 0x15eda1db0; frame = (8 7; 584 29); opaque = NO; autoresize = W+H; layer = <CALayer: 0x170433ac0>>
     2015-11-16 10:02:10.508 MLLSalesAssistant[1298:479083] <UISearchBarBackground: 0x15eda1a20; frame = (0 0; 600 44); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x1704335e0>>
     2015-11-16 10:02:10.509 MLLSalesAssistant[1298:479083] <UISearchBarTextField: 0x15eda4670; frame = (0 0; 0 0); text = ''; clipsToBounds = YES; opaque = NO; layer = <CALayer: 0x17043bfc0>>
     2015-11-16 10:02:10.510 MLLSalesAssistant[1298:479083] <_UISearchBarSearchFieldBackgroundView: 0x15eda5910; frame = (0 0; 0 0); opaque = NO; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x17043c4a0>>
     */
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        NSLog(@"%@", subView);
        for (UIView *subSubView in subView.subviews) {
            NSLog(@"%@", subSubView);
            if ([subSubView isKindOfClass:NSClassFromString(@"UITextField")]) {
                UITextField *textField = (UITextField *)subSubView;
                CGRect frame = textField.bounds;
                frame.size.height = 32;
                
                //调整输入框的高度为32，默认是28
                textField.bounds = frame;
                
                for (UIView *textFieldSubView in textField.subviews) {
                    NSLog(@"%@", textFieldSubView);
                    
                    if ([textFieldSubView isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView = (UIImageView *)textFieldSubView;
                        CGRect imageBounds = imageView.bounds;
                        imageBounds.size = CGSizeMake(15, 15);
                        
                        //修改搜索图标的大小，默认是13，13
                        imageView.bounds = imageBounds;
//                        break;
                    }
                    
                }
                break;
            }
        }
    }
}

- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


#pragma mark - Publck

- (void)setSearchIcon:(UIImage *)searchIcon {
    if (searchIcon) {
        [self setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
}
@end
