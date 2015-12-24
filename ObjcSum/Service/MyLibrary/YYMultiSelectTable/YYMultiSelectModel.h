//
//  YYMultiSelectModel.h
//  justice
//
//  Created by sihuan on 15/12/21.
//  Copyright © 2015年 kkou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMultiSelectModel : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL checked;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
