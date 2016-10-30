//
//  UISearchDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/11/13.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UISearchDemo.h"
#import "YYSearchBar.h"

@interface UISearchDemo ()

@end

@implementation UISearchDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.searchBar];
    _searchBar.frame = CGRectMake(0,40, 320, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YYSearchBar *)searchBar {
    if (!_searchBar) {
        YYSearchBar *searchBar = [[YYSearchBar alloc] init];
        searchBar.showsCancelButton = YES;
        _searchBar = searchBar;
    }
    return _searchBar;
}
@end
