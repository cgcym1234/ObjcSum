//
//  DemoCellModel2.h
//  ObjcSum
//
//  Created by yangyuan on 2016/9/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMRenderableTableView.h"


@interface DemoCellModel2 : NSObject<JMRenderableCellModel>

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) NSString *text;

@end
