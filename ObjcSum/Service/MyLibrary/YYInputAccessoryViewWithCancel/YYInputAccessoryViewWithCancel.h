//
//  YYInputAccessoryViewWithCancel.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/10/8.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYInputAccessoryViewWithCancelType) {
    YYInputAccessoryViewWithCancelTypeCancel,   //取消
    YYInputAccessoryViewWithCancelTypeDone,     //完成
};

@class YYInputAccessoryViewWithCancel;

//点击取消，完成
typedef void (^YYInputAccessoryViewWithCancelDidClickedBlock)(YYInputAccessoryViewWithCancel *view, YYInputAccessoryViewWithCancelType type);

@interface YYInputAccessoryViewWithCancel : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (copy, nonatomic) YYInputAccessoryViewWithCancelDidClickedBlock didClickedBlock;

+ (instancetype)instanceFromNib;

@end
