//
//  GoodsDetailNomalViewController.m
//  MLLCustomer
//
//  Created by sihuan on 16/6/13.
//  Copyright © 2016年 Meilele. All rights reserved.
//

#import "GoodsDetailNomalViewController.h"
#import "DemoCellModel.h"

@implementation GoodsDetailNomalViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}



- (void)requestData {
    [self requestData:NO];
}

- (void)requestData:(BOOL)appendData {
    self.dataArray = [NSMutableArray<GoodsDetailModel> new];
    
    NSArray *texts = @[@"test1", @"test2test2test2test2test2test2test2test2test2test2test2test2test2", @"test3", @"test4test2test2test2test2", @"test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5test5", @"test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6test6", @"test7", @"test8", @"test9test9test9test9test9",@"101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010", @"111111111111111111111111111111111"];
    
    for (NSString *text in texts) {
        DemoCellModel *model = [DemoCellModel new];
        model.text = text;
        [self.dataArray addObject:model];
    }
    
    [self reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
