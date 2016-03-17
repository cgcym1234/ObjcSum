//
//  TouchEventDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "TouchEventDemo.h"

@interface TouchEventDemo ()

@end

@implementation TouchEventDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"EventDemo" bundle:nil] instantiateInitialViewController];
}
@end
