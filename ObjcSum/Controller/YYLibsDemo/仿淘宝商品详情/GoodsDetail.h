//
//  GoodsDetail.h
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#ifndef GoodsDetail_h
#define GoodsDetail_h

#import <UIKit/UIKit.h>


@protocol GoodsDetailModel <NSObject>

@required
@property (nonatomic, strong, readonly) NSString *cellIdentifier;

@end

@protocol GoodsDetailCellDelegate <NSObject>

@required
- (void)updateWithModel:(id)model atIndexPath:(NSIndexPath *)indexPath inView:(UIView *)view;

@end

#pragma mark - 商品详情模块中的跳转事件

#define GoodsDetailEventOffset (80)

typedef NS_ENUM(NSUInteger, GoodsDetailEventType) {
    //左拉事件
    GoodsDetailEventTypePullLeft,
    //上拉事件
    GoodsDetailEventTypePullUp,
    //下拉事件
    GoodsDetailEventTypePullDown
};

@protocol GoodsDetailEventDelegate <NSObject>

- (void)viewController:(UIViewController *)controller didTriggerEnent:(GoodsDetailEventType)event;

@end


#endif /* GoodsDetail_h */
