//
//  FastRecordCellModel.h
//  MLLSalesAssistant
//
//  Created by sihuan on 15/9/28.
//  Copyright © 2015年 Meilele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastRecord.h"
#import "FastRecordAccessoryView.h"

@class FastRecordModel;

@interface FastRecordCellModel : NSObject

@property (copy, nonatomic) NSString *managedObjectID;//记录号
@property (copy, nonatomic) NSString *userId;//用户唯一标识

@property (copy, nonatomic) NSString *title;
@property (nonatomic) FastRecordType type;

@property (copy, nonatomic) NSString *recordDateStr;//谁手记生成时间
@property (copy, nonatomic) NSDate *recordDate;//谁手记生成时间

@property (copy, nonatomic) NSString *clockDateStr;//提醒时间
@property (copy, nonatomic) NSDate *clockDate;//提醒时间

@property (copy, nonatomic) NSString *recordText;//谁手记文本内容

@property (copy, nonatomic) NSURL *recordVoicePath;//谁手记本地语音路径
@property (nonatomic, strong) NSString *recordVoiceDuration;//语音时间

@property (strong, nonatomic) NSMutableArray *recordImages;//谁手记图片

@property (copy, nonatomic) NSString *customerId;//选择的客户id
@property (copy, nonatomic) NSString *customerName;//客户名字

/*
 将FastRecordModel数组转换成FastRecordCellModel数组
 */
+ (NSMutableArray *)arrayFromFastRecordModels:(NSArray *)arr;
- (instancetype)initWithFastRecordModel:(FastRecordModel *)model;

- (void)setType:(FastRecordType)type;

@end
