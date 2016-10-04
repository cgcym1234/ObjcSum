//
//  YYBaseViewController.h
//  ObjcSum
//
//  Created by sihuan on 2016/8/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBaseViewController : UIViewController

///< 来源页面(埋点专用)
@property (nonatomic, copy) NSString *fromPage;

///< 进入下个页面的锁管理
@property (nonatomic, assign) BOOL isGoing;


@end






























