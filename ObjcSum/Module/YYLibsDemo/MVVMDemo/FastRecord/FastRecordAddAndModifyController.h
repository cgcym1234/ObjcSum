//
//  FastRecordAddAndModifyController.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecord.h"

@class FastRecordCellModel;
@class FastRecordModel;
@class FastRecordAddAndModifyController;

typedef void (^FastRecordAddAndModifyControllerDidCompletedBlock)(FastRecordModel *entity, FastRecordCellModel *item);

@interface FastRecordAddAndModifyController : UITableViewController

@property (nonatomic, strong) FastRecordCellModel *fastRecordCellModel;
@property (nonatomic, strong) FastRecordModel *fastRecordModel;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) FastRecordAddAndModifyControllerDidCompletedBlock didCompletedBlock;

/*
 新建随手记接口
 */
+ (void)presentFromViewController:(UIViewController *)fromVc;

/*
 修改随手记接口
 */
+ (void)modifyRecordFromViewController:(UIViewController *)fromVc withObject:(FastRecordCellModel *)item andObject:(FastRecordModel*)model;

/*
 新建随手记接口
 
 customerInfo：传入需要选中的客户信息,字典比如： @{CustomerInfoNameKey:@"name", CustomerIdKey:@"id"};
 completion： 保存成功后的回调，回调中返回的数据可用于 修改随手记接口
 */
+ (void)addRecordFromViewController:(UIViewController *)fromVc customerInfo:(NSDictionary *)customerInfo completion:(FastRecordAddAndModifyControllerDidCompletedBlock)completion;

@end
