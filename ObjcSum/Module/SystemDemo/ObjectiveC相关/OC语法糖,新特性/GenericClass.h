//
//  GenericClass.h
//  ObjcSum
//
//  Created by yangyuan on 2018/6/27.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

///定义泛型类, 还可以让类型参数继承自某个类或者遵守某个协议
@interface GenericClass<T: UIView*> : NSObject

@property (nonatomic, copy, readonly) NSArray<T> *container;

- (void)add:(T)obj;
- (T)removeLast;

@end


///在子类中指定父类泛型类型
@interface GenericClass2: GenericClass<UITableView *>


@end
